// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:pedantic/pedantic.dart';

import 'crc32c.dart';
import 'rest_list_result.dart';
import 'rest_task_snapshot.dart';

/// A pure Dart implementation of [FirebaseStoragePlatform] using REST APIs.
class RestFirebaseStorage extends FirebaseStoragePlatform {
  /// Create an instance of [RestFirebaseStorage].
  RestFirebaseStorage({required FirebaseApp app, required String bucket})
      : super(appInstance: app, bucket: bucket);

  final Map<String, RestReference> _references = {};

  @override
  FirebaseStoragePlatform delegateFor({
    required FirebaseApp app,
    required String bucket,
  }) {
    return RestFirebaseStorage(app: app, bucket: bucket);
  }

  @override
  ReferencePlatform ref(String path) {
    return _references.putIfAbsent(path, () => RestReference(this, path));
  }

  int _maxOperationRetryTime = 120000;
  int _maxUploadRetryTime = 600000;
  int _maxDownloadRetryTime = 600000;

  @override
  int get maxOperationRetryTime => _maxOperationRetryTime;

  @override
  int get maxUploadRetryTime => _maxUploadRetryTime;

  @override
  int get maxDownloadRetryTime => _maxDownloadRetryTime;

  @override
  void setMaxOperationRetryTime(int time) => _maxOperationRetryTime = time;

  @override
  void setMaxUploadRetryTime(int time) => _maxUploadRetryTime = time;

  @override
  void setMaxDownloadRetryTime(int time) => _maxDownloadRetryTime = time;

  String? _emulatorHost;
  int? _emulatorPort;

  @override
  Future<void> useStorageEmulator(String host, int port) async {
    _emulatorHost = host;
    _emulatorPort = port;
  }

  /// The base URI for the storage service.
  Uri get baseUri {
    if (_emulatorHost != null && _emulatorPort != null) {
      return Uri.http('$_emulatorHost:$_emulatorPort', '/v0/b/$bucket/o');
    }
    return Uri.https('firebasestorage.googleapis.com', '/v0/b/$bucket/o');
  }

  /// Returns the headers for the request, including authentication tokens.
  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {};

    // Auth Token
    try {
      final auth = FirebaseAuth.instanceFor(app: app);
      final idToken = await auth.currentUser?.getIdToken();
      if (idToken != null) {
        headers['Authorization'] = 'Firebase $idToken';
      }
    } catch (_) {}

    // App Check Token
    try {
      final appCheck = FirebaseAppCheck.instanceFor(app: app);
      final token = await appCheck.getToken();
      if (token != null) {
        headers['X-Firebase-AppCheck'] = token;
      }
    } catch (_) {}

    return headers;
  }
}

/// A pure Dart implementation of [ReferencePlatform] using REST APIs.
class RestReference extends ReferencePlatform {
  /// Create an instance of [RestReference].
  RestReference(RestFirebaseStorage storage, String path)
      : _storage = storage,
        super(storage, path);

  final RestFirebaseStorage _storage;

  Uri get _uri {
    // Firebase Storage REST API expects the path to be URL encoded
    final encodedPath = Uri.encodeComponent(
        fullPath.startsWith('/') ? fullPath.substring(1) : fullPath);
    return _storage.baseUri
        .replace(path: '${_storage.baseUri.path}/$encodedPath');
  }

  @override
  Future<void> delete() async {
    final response = await http.delete(
      _uri,
      headers: await _storage.getHeaders(),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'delete-failed',
        message: 'Failed to delete object: ${response.body}',
      );
    }
  }

  @override
  Future<String> getDownloadURL() async {
    final metadata = await getMetadata();
    // Firebase Storage download URLs are constructed using a downloadToken in metadata
    final downloadTokens =
        metadata.customMetadata?['firebaseStorageDownloadTokens'];
    if (downloadTokens == null || downloadTokens.isEmpty) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'no-download-token',
        message: 'No download token found for object.',
      );
    }

    // The first token is usually used
    final token = downloadTokens.split(',').first;
    return _uri
        .replace(queryParameters: {'alt': 'media', 'token': token}).toString();
  }

  @override
  Future<FullMetadata> getMetadata() async {
    final response = await http.get(
      _uri,
      headers: await _storage.getHeaders(),
    );

    if (response.statusCode != 200) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'metadata-failed',
        message: 'Failed to get metadata: ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return _mapMetadata(data);
  }

  @override
  Future<Uint8List?> getData(int maxSize) async {
    final response = await http.get(
      _uri.replace(queryParameters: {'alt': 'media'}),
      headers: await _storage.getHeaders(),
    );

    if (response.statusCode != 200) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'download-failed',
        message: 'Failed to download data: ${response.body}',
      );
    }

    if (response.bodyBytes.length > maxSize) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'canceled',
        message: 'The maximum allowed size has been exceeded.',
      );
    }

    final data = response.bodyBytes;

    // Checksum validation (borrowed logic from google_cloud_storage)
    final hashHeader = response.headers['x-goog-hash'];
    if (hashHeader != null) {
      final hashes = _parseHashes(hashHeader.split(','));
      if (hashes['crc32c'] case final crc32c?) {
        final calculatedCrc32c = Crc32c()..update(data);
        if (calculatedCrc32c.toBase64() != crc32c) {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'checksum-mismatch',
            message: 'CRC32C checksum mismatch.',
          );
        }
      }
    }

    return data;
  }

  Map<String, String> _parseHashes(List<String> hashes) {
    final result = <String, String>{};
    for (final hash in hashes) {
      final equalsIndex = hash.indexOf('=');
      if (equalsIndex != -1) {
        result[hash.substring(0, equalsIndex).trim()] =
            hash.substring(equalsIndex + 1).trim();
      }
    }
    return result;
  }
  FullMetadata _mapMetadata(Map<String, dynamic> data) {
    return FullMetadata({
      'bucket': data['bucket'],
      'contentDisposition': data['contentDisposition'],
      'contentEncoding': data['contentEncoding'],
      'contentLanguage': data['contentLanguage'],
      'contentType': data['contentType'],
      'customMetadata': data['metadata'] != null
          ? Map<String, String>.from(data['metadata'])
          : null,
      'fullPath': data['name'],
      'generation': data['generation'],
      'metageneration': data['metageneration'],
      'name': (data['name'] as String).split('/').last,
      'size': int.tryParse(data['size']?.toString() ?? '0') ?? 0,
      'timeCreated': data['timeCreated'] != null
          ? DateTime.parse(data['timeCreated']).millisecondsSinceEpoch
          : null,
      'updated': data['updated'] != null
          ? DateTime.parse(data['updated']).millisecondsSinceEpoch
          : null,
      'md5Hash': data['md5Hash'],
      'cacheControl': data['cacheControl'],
    });
  }

  @override
  Future<ListResultPlatform> list([ListOptions? options]) async {
    final queryParams = <String, String>{
      'prefix': fullPath.endsWith('/')
          ? fullPath.substring(1)
          : (fullPath == '/' ? '' : '${fullPath.substring(1)}/'),
    };
    if (options?.maxResults != null) {
      queryParams['maxResults'] = options!.maxResults.toString();
    }
    if (options?.pageToken != null) {
      queryParams['pageToken'] = options!.pageToken!;
    }

    final listUri = _storage.baseUri.replace(queryParameters: queryParams);
    final response =
        await http.get(listUri, headers: await _storage.getHeaders());

    if (response.statusCode != 200) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'list-failed',
        message: 'Failed to list objects: ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return RestListResult(
      _storage,
      nextPageToken: data['nextPageToken'],
      items: (data['items'] as List? ?? [])
          .map((item) => item['name'] as String)
          .toList(),
      prefixes: (data['prefixes'] as List? ?? [])
          .map((prefix) => prefix as String)
          .toList(),
    );
  }

  @override
  Future<ListResultPlatform> listAll() async {
    List<String> items = [];
    List<String> prefixes = [];
    String? pageToken;

    do {
      final result = await list(ListOptions(pageToken: pageToken));
      items.addAll(result.items.map((i) => i.fullPath));
      prefixes.addAll(result.prefixes.map((p) => p.fullPath));
      pageToken = result.nextPageToken;
    } while (pageToken != null);

    return RestListResult(
      _storage,
      items: items,
      prefixes: prefixes,
    );
  }

  @override
  TaskPlatform putData(Uint8List data, [SettableMetadata? metadata]) {
    if (data.length > 1024 * 1024) {
      return RestResumableUploadTask(this, data, metadata);
    }
    return RestUploadTask(this, data, metadata);
  }

  @override
  TaskPlatform putFile(File file, [SettableMetadata? metadata]) {
    final data = file.readAsBytesSync();
    if (data.length > 1024 * 1024) {
      return RestResumableUploadTask(this, data, metadata);
    }
    return RestUploadTask(this, data, metadata);
  }

  @override
  TaskPlatform putString(String data, PutStringFormat format,
      [SettableMetadata? metadata]) {
    // Basic implementation for now - assuming already encoded into a format that can be treated as bytes
    return putData(Uint8List.fromList(utf8.encode(data)), metadata);
  }

  @override
  Future<FullMetadata> updateMetadata(SettableMetadata metadata) async {
    final response = await http.patch(
      _uri,
      headers: {
        ...await _storage.getHeaders(),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'cacheControl': metadata.cacheControl,
        'contentDisposition': metadata.contentDisposition,
        'contentEncoding': metadata.contentEncoding,
        'contentLanguage': metadata.contentLanguage,
        'contentType': metadata.contentType,
        'metadata': metadata.customMetadata,
      }),
    );

    if (response.statusCode != 200) {
      throw FirebaseException(
        plugin: 'firebase_storage',
        code: 'metadata-failed',
        message: 'Failed to update metadata: ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return _mapMetadata(data);
  }

  @override
  TaskPlatform writeToFile(File file) {
    return RestDownloadTask(this, file);
  }
}

/// A pure Dart implementation of [TaskPlatform] for uploading data.
class RestUploadTask extends TaskPlatform {
  /// Create an instance of [RestUploadTask].
  RestUploadTask(this.reference, this.data, this.metadata) {
    unawaited(_startUpload());
  }

  /// The reference to the storage object.
  final RestReference reference;

  /// The data to be uploaded.
  final Uint8List data;

  /// The metadata to be set on the storage object.
  final SettableMetadata? metadata;

  final StreamController<TaskSnapshotPlatform> _controller =
      StreamController.broadcast();
  late TaskSnapshotPlatform _snapshot;
  final Completer<TaskSnapshotPlatform> _completer = Completer();

  @override
  Stream<TaskSnapshotPlatform> get snapshotEvents => _controller.stream;

  @override
  TaskSnapshotPlatform get snapshot => _snapshot;

  @override
  Future<TaskSnapshotPlatform> get onComplete => _completer.future;

  Future<void> _startUpload() async {
    _snapshot = RestTaskSnapshot(
      reference._storage,
      TaskState.running,
      {
        'bytesTransferred': 0,
        'totalBytes': data.length,
        'path': reference.fullPath,
      },
    );
    _controller.add(_snapshot);

    try {
      // For simple upload, the path is slightly different or needs a 'name' param
      final uploadUri = reference._storage.baseUri.replace(
        queryParameters: {
          'name': reference.fullPath.startsWith('/')
              ? reference.fullPath.substring(1)
              : reference.fullPath
        },
      );

      final response = await http.post(
        uploadUri,
        headers: {
          ...await reference._storage.getHeaders(),
          if (metadata?.contentType != null)
            'Content-Type': metadata!.contentType!,
        },
        body: data,
      );

      if (response.statusCode != 200) {
        throw FirebaseException(
          plugin: 'firebase_storage',
          code: 'upload-failed',
          message: 'Failed to upload: ${response.body}',
        );
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      _snapshot = RestTaskSnapshot(
        reference._storage,
        TaskState.success,
        {
          'bytesTransferred': data.length,
          'totalBytes': data.length,
          'path': reference.fullPath,
          'metadata': responseData,
        },
      );
      _controller.add(_snapshot);
      _completer.complete(_snapshot);
    } catch (e, stack) {
      _snapshot = RestTaskSnapshot(
        reference._storage,
        TaskState.error,
        {
          'bytesTransferred': 0,
          'totalBytes': data.length,
          'path': reference.fullPath,
        },
      );
      _controller.addError(e, stack);
      _completer.completeError(e, stack);
    } finally {
      await _controller.close();
    }
  }

  @override
  Future<bool> cancel() async => false; // Not supported in simple REST impl

  @override
  Future<bool> pause() async => false; // Not supported in simple REST impl

  @override
  Future<bool> resume() async => false; // Not supported in simple REST impl
}

/// A pure Dart implementation of [TaskPlatform] for downloading data.
class RestDownloadTask extends TaskPlatform {
  /// Create an instance of [RestDownloadTask].
  RestDownloadTask(this.reference, this.file) {
    unawaited(_startDownload());
  }

  /// The reference to the storage object.
  final RestReference reference;

  /// The file to which the data will be downloaded.
  final File file;

  final StreamController<TaskSnapshotPlatform> _controller =
      StreamController.broadcast();
  late TaskSnapshotPlatform _snapshot;
  final Completer<TaskSnapshotPlatform> _completer = Completer();

  @override
  Stream<TaskSnapshotPlatform> get snapshotEvents => _controller.stream;

  @override
  TaskSnapshotPlatform get snapshot => _snapshot;

  @override
  Future<TaskSnapshotPlatform> get onComplete => _completer.future;

  Future<void> _startDownload() async {
    try {
      final data = await reference
          .getData(100 * 1024 * 1024); // 100MB limit for simple impl
      if (data != null) {
        await file.writeAsBytes(data);
      }
      _snapshot = RestTaskSnapshot(
        reference._storage,
        TaskState.success,
        {
          'bytesTransferred': data?.length ?? 0,
          'totalBytes': data?.length ?? 0,
          'path': reference.fullPath,
        },
      );
      _controller.add(_snapshot);
      _completer.complete(_snapshot);
    } catch (e, stack) {
      _snapshot = RestTaskSnapshot(
        reference._storage,
        TaskState.error,
        {
          'bytesTransferred': 0,
          'totalBytes': 0,
          'path': reference.fullPath,
        },
      );
      _controller.addError(e, stack);
      _completer.completeError(e, stack);
    } finally {
      await _controller.close();
    }
  }

  @override
  Future<bool> cancel() async => false;

  @override
  Future<bool> pause() async => false;

  @override
  Future<bool> resume() async => false;
}

/// A pure Dart implementation of [TaskPlatform] for resumable uploads.
class RestResumableUploadTask extends TaskPlatform {
  /// Create an instance of [RestResumableUploadTask].
  RestResumableUploadTask(this.reference, this.data, this.metadata) {
    unawaited(_startUpload());
  }

  /// The reference to the storage object.
  final RestReference reference;
  /// The data to be uploaded.
  final Uint8List data;
  /// The metadata to be set on the storage object.
  final SettableMetadata? metadata;

  final StreamController<TaskSnapshotPlatform> _controller = StreamController.broadcast();
  late TaskSnapshotPlatform _snapshot;
  final Completer<TaskSnapshotPlatform> _completer = Completer();

  @override
  Stream<TaskSnapshotPlatform> get snapshotEvents => _controller.stream;

  @override
  TaskSnapshotPlatform get snapshot => _snapshot;

  @override
  Future<TaskSnapshotPlatform> get onComplete => _completer.future;

  Future<void> _startUpload() async {
    _snapshot = RestTaskSnapshot(
      reference._storage,
      TaskState.running,
      {
        'bytesTransferred': 0,
        'totalBytes': data.length,
        'path': reference.fullPath,
      },
    );
    _controller.add(_snapshot);

    try {
      // 1. Initiate resumable upload
      final initiateUri = reference._storage.baseUri.replace(
        queryParameters: {
          'uploadType': 'resumable',
          'name': reference.fullPath.startsWith('/') ? reference.fullPath.substring(1) : reference.fullPath,
        },
      );

      final initiateResponse = await http.post(
        initiateUri,
        headers: {
          ...await reference._storage.getHeaders(),
          'X-Goog-Upload-Protocol': 'resumable',
          'X-Goog-Upload-Command': 'start',
          'X-Goog-Upload-Header-Content-Length': data.length.toString(),
          if (metadata?.contentType != null) 'X-Goog-Upload-Header-Content-Type': metadata!.contentType!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(metadata != null ? {
          'cacheControl': metadata!.cacheControl,
          'contentDisposition': metadata!.contentDisposition,
          'contentEncoding': metadata!.contentEncoding,
          'contentLanguage': metadata!.contentLanguage,
          'contentType': metadata!.contentType,
          'metadata': metadata!.customMetadata,
        } : {}),
      );

      if (initiateResponse.statusCode != 200) {
        throw FirebaseException(
          plugin: 'firebase_storage',
          code: 'upload-failed',
          message: 'Failed to initiate resumable upload: ${initiateResponse.body}',
        );
      }

      final uploadUrl = initiateResponse.headers['x-goog-upload-url'];
      if (uploadUrl == null) {
        throw FirebaseException(
          plugin: 'firebase_storage',
          code: 'upload-failed',
          message: 'No upload URL returned from initiation.',
        );
      }

      final uri = Uri.parse(uploadUrl);

      // 2. Upload data in chunks (or all at once for simplicity in this stab, 
      // but using the resumable protocol).
      // Standard GCS expects chunks to be multiples of 256KB.
      
      const chunkSize = 256 * 1024;
      int offset = 0;

      while (offset < data.length) {
        final end = (offset + chunkSize < data.length) ? offset + chunkSize : data.length;
        final chunk = data.sublist(offset, end);
        final isLast = end == data.length;

        final response = await http.put(
          uri,
          headers: {
            ...await reference._storage.getHeaders(),
            'X-Goog-Upload-Command': isLast ? 'upload, finalize' : 'upload',
            'X-Goog-Upload-Offset': offset.toString(),
          },
          body: chunk,
        );

        if (response.statusCode != 200) {
           throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'upload-failed',
            message: 'Failed to upload chunk: ${response.body}',
          );
        }

        offset = end;
        _snapshot = RestTaskSnapshot(
          reference._storage,
          isLast ? TaskState.success : TaskState.running,
          {
            'bytesTransferred': offset,
            'totalBytes': data.length,
            'path': reference.fullPath,
            if (isLast) 'metadata': jsonDecode(response.body),
          },
        );
        _controller.add(_snapshot);
      }

      _completer.complete(_snapshot);
    } catch (e, stack) {
      _snapshot = RestTaskSnapshot(
        reference._storage,
        TaskState.error,
        {
          'bytesTransferred': 0,
          'totalBytes': data.length,
          'path': reference.fullPath,
        },
      );
      _controller.addError(e, stack);
      _completer.completeError(e, stack);
    } finally {
      await _controller.close();
    }
  }

  @override
  Future<bool> cancel() async => false;

  @override
  Future<bool> pause() async => false;

  @override
  Future<bool> resume() async => false;
}
