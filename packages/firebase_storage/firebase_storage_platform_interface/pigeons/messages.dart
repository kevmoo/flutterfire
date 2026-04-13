// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: one_member_abstracts

import 'package:pigeon/pigeon.dart';

@Configure(
  Options(
    dartPackageName: 'firebase_storage',
    dartOptions: DartOptions(
      extraImports: [
        'package:flutter/foundation.dart',
        'package:flutter/services.dart',
      ],
    ),
    dartOut: '../firebase_storage/lib/src/pigeon/messages.pigeon.dart',
    // We export in the lib folder to expose the class to other packages.
    dartTestOut: '../firebase_storage/lib/src/pigeon/test_api.dart',
    kotlinOut:
        '../firebase_storage/android/src/main/kotlin/io/flutter/plugins/firebase/storage/GeneratedAndroidFirebaseStorage.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'io.flutter.plugins.firebase.storage',
    ),
    swiftOut:
        '../firebase_storage/ios/firebase_storage/Sources/firebase_storage/FirebaseStorageMessages.g.swift',
    cppHeaderOut: '../firebase_storage/windows/messages.g.h',
    cppSourceOut: '../firebase_storage/windows/messages.g.cpp',
    cppOptions: CppOptions(namespace: 'firebase_storage_windows'),
    copyrightHeader: 'pigeons/copyright.txt',
  ),
)
class StorageFirebaseApp {
  const StorageFirebaseApp({
    required this.appName,
    required this.tenantId,
    required this.bucket,
  });

  final String appName;
  final String? tenantId;
  final String bucket;
}

/// The type of operation that generated the action code from calling
/// [TaskState].
enum StorageTaskState {
  /// Indicates the task has been paused by the user.
  paused,

  /// Indicates the task is currently in-progress.
  running,

  /// Indicates the task has successfully completed.
  success,

  /// Indicates the task was canceled.
  canceled,

  /// Indicates the task failed with an error.
  error,
}

class StorageReference {
  const StorageReference({
    required this.bucket,
    required this.fullPath,
    required this.name,
  });

  final String bucket;
  final String fullPath;
  final String name;
}

class FullMetaData {
  const FullMetaData({
    required this.metadata,
  });
  final Map<String?, Object?>? metadata;
}

class ListOptions {
  const ListOptions({
    required this.maxResults,
    this.pageToken,
  });

  /// If set, limits the total number of `prefixes` and `items` to return.
  ///
  /// The default and maximum maxResults is 1000.
  final int maxResults;

  /// The nextPageToken from a previous call to list().
  ///
  /// If provided, listing is resumed from the previous position.
  final String? pageToken;
}

class SettableMetadata {
  /// Creates a new [SettableMetadata] instance.
  SettableMetadata({
    this.cacheControl,
    this.contentDisposition,
    this.contentEncoding,
    this.contentLanguage,
    this.contentType,
    this.customMetadata,
  });

  /// Served as the 'Cache-Control' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control.
  final String? cacheControl;

  /// Served as the 'Content-Disposition' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition.
  final String? contentDisposition;

  /// Served as the 'Content-Encoding' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding.
  final String? contentEncoding;

  /// Served as the 'Content-Language' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language.
  final String? contentLanguage;

  /// Served as the 'Content-Type' header on object download.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type.
  final String? contentType;

  /// Additional user-defined custom metadata.
  final Map<String?, String?>? customMetadata;
}

class StorageTaskSnapShot {
  const StorageTaskSnapShot({
    required this.bytesTransferred,
    required this.metadata,
    required this.state,
    required this.totalBytes,
  });

  final int bytesTransferred;
  final FullMetaData? metadata;
  final StorageTaskState state;
  final int totalBytes;
}

class ListResult {
  const ListResult({
    required this.items,
    required this.pageToken,
    required this.prefixs,
  });

  final List<StorageReference?> items;
  final String? pageToken;
  final List<StorageReference?> prefixs;
}

@HostApi(dartHostTestHandler: 'TestFirebaseStorageHostApi')
abstract class FirebaseStorageHostApi {
  @async
  StorageReference getReferencebyPath(
    StorageFirebaseApp app,
    String path,
    String? bucket,
  );
  @async
  void setMaxOperationRetryTime(
    StorageFirebaseApp app,
    int time,
  );
  @async
  void setMaxUploadRetryTime(
    StorageFirebaseApp app,
    int time,
  );
  @async
  void setMaxDownloadRetryTime(
    StorageFirebaseApp app,
    int time,
  );

  @async
  void useStorageEmulator(
    StorageFirebaseApp app,
    String host,
    int port,
  );

  // APIs for Reference class

  @async
  void referenceDelete(
    StorageFirebaseApp app,
    StorageReference reference,
  );

  @async
  String referenceGetDownloadURL(
    StorageFirebaseApp app,
    StorageReference reference,
  );

  @async
  FullMetaData referenceGetMetaData(
    StorageFirebaseApp app,
    StorageReference reference,
  );

  @async
  ListResult referenceList(
    StorageFirebaseApp app,
    StorageReference reference,
    ListOptions options,
  );

  @async
  ListResult referenceListAll(
    StorageFirebaseApp app,
    StorageReference reference,
  );

  @async
  Uint8List? referenceGetData(
    StorageFirebaseApp app,
    StorageReference reference,
    int maxSize,
  );

  @async
  String referencePutData(
    StorageFirebaseApp app,
    StorageReference reference,
    Uint8List data,
    SettableMetadata settableMetaData,
    int handle,
  );

  @async
  String referencePutString(
    StorageFirebaseApp app,
    StorageReference reference,
    String data,
    int format,
    SettableMetadata settableMetaData,
    int handle,
  );

  @async
  String referencePutFile(
    StorageFirebaseApp app,
    StorageReference reference,
    String filePath,
    SettableMetadata? settableMetaData,
    int handle,
  );

  @async
  String referenceDownloadFile(
    StorageFirebaseApp app,
    StorageReference reference,
    String filePath,
    int handle,
  );

  @async
  FullMetaData referenceUpdateMetadata(
    StorageFirebaseApp app,
    StorageReference reference,
    SettableMetadata metadata,
  );

  // APIs for Task class
  @async
  Map<String, Object> taskPause(
    StorageFirebaseApp app,
    int handle,
  );

  @async
  Map<String, Object> taskResume(
    StorageFirebaseApp app,
    int handle,
  );

  @async
  Map<String, Object> taskCancel(
    StorageFirebaseApp app,
    int handle,
  );
}
