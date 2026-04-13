// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// ignore_for_file: one_member_abstracts

import 'package:pigeon/pigeon.dart';

@Configure(
  Options(
    dartPackageName: 'cloud_firestore',
    dartOptions: DartOptions(
      extraImports: [
        'package:flutter/foundation.dart',
        'package:flutter/services.dart',
      ],
    ),
    dartOut: '../cloud_firestore/lib/src/pigeon/messages.pigeon.dart',
    // We export in the lib folder to expose the class to other packages.
    dartTestOut: '../cloud_firestore/lib/src/pigeon/test_api.dart',
    javaOut:
        '../cloud_firestore/android/src/main/java/io/flutter/plugins/firebase/firestore/GeneratedAndroidFirebaseFirestore.java',
    javaOptions: JavaOptions(
      package: 'io.flutter.plugins.firebase.firestore',
      className: 'GeneratedAndroidFirebaseFirestore',
    ),
    objcHeaderOut:
        '../cloud_firestore/ios/cloud_firestore/Sources/cloud_firestore/include/cloud_firestore/Public/FirestoreMessages.g.h',
    objcSourceOut:
        '../cloud_firestore/ios/cloud_firestore/Sources/cloud_firestore/FirestoreMessages.g.m',
    cppHeaderOut: '../cloud_firestore/windows/messages.g.h',
    cppSourceOut: '../cloud_firestore/windows/messages.g.cpp',
    cppOptions: CppOptions(namespace: 'cloud_firestore_windows'),
    copyrightHeader: 'pigeons/copyright.txt',
  ),
)
class FirebaseSettings {
  const FirebaseSettings({
    required this.persistenceEnabled,
    required this.host,
    required this.sslEnabled,
    required this.cacheSizeBytes,
    required this.ignoreUndefinedProperties,
  });

  final bool? persistenceEnabled;
  final String? host;
  final bool? sslEnabled;
  final int? cacheSizeBytes;
  final bool ignoreUndefinedProperties;
}

// We prefix the class name with `Auth` to avoid a conflict with
// other classes in other packages.
class FirestoreFirebaseApp {
  const FirestoreFirebaseApp({
    required this.appName,
    required this.settings,
    required this.databaseURL,
  });

  final String appName;
  final FirebaseSettings settings;
  final String databaseURL;
}

class SnapshotMetadata {
  const SnapshotMetadata({
    required this.hasPendingWrites,
    required this.isFromCache,
  });

  final bool hasPendingWrites;
  final bool isFromCache;
}

class DocumentSnapshot {
  const DocumentSnapshot({
    required this.path,
    required this.data,
    required this.metadata,
  });

  final String path;
  final Map<String?, Object?>? data;
  final SnapshotMetadata metadata;
}

/// An enumeration of document change types.
enum DocumentChangeType {
  /// Indicates a new document was added to the set of documents matching the
  /// query.
  added,

  /// Indicates a document within the query was modified.
  modified,

  /// Indicates a document within the query was removed (either deleted or no
  /// longer matches the query.
  removed,
}

class DocumentChange {
  const DocumentChange({
    required this.type,
    required this.document,
    required this.oldIndex,
    required this.newIndex,
  });

  final DocumentChangeType type;
  final DocumentSnapshot document;
  final int oldIndex;
  final int newIndex;
}

class QuerySnapshot {
  const QuerySnapshot({
    required this.documents,
    required this.documentChanges,
    required this.metadata,
  });

  final List<DocumentSnapshot?> documents;
  final List<DocumentChange?> documentChanges;
  final SnapshotMetadata metadata;
}

/// An enumeration of firestore source types.
enum Source {
  /// Causes Firestore to try to retrieve an up-to-date (server-retrieved) snapshot, but fall back to
  /// returning cached data if the server can't be reached.
  serverAndCache,

  /// Causes Firestore to avoid the cache, generating an error if the server cannot be reached. Note
  /// that the cache will still be updated if the server request succeeds. Also note that
  /// latency-compensation still takes effect, so any pending write operations will be visible in the
  /// returned data (merged into the server-provided data).
  server,

  /// Causes Firestore to immediately return a value from the cache, ignoring the server completely
  /// (implying that the returned value may be stale with respect to the value on the server). If
  /// there is no data in the cache to satisfy the `get` call,
  /// [DocumentReference.get] will throw a [FirebaseException] and
  /// [Query.get] will return an empty [QuerySnapshotPlatform] with no documents.
  cache,
}

/// The listener retrieves data and listens to updates from the local Firestore cache only.
/// If the cache is empty, an empty snapshot will be returned.
/// Snapshot events will be triggered on cache updates, like local mutations or load bundles.
///
/// Note that the data might be stale if the cache hasn't synchronized with recent server-side changes.
enum ListenSource {
  /// The default behavior. The listener attempts to return initial snapshot from cache and retrieve up-to-date snapshots from the Firestore server.
  /// Snapshot events will be triggered on local mutations and server side updates.
  defaultSource,

  /// The listener retrieves data and listens to updates from the local Firestore cache only.
  /// If the cache is empty, an empty snapshot will be returned.
  /// Snapshot events will be triggered on cache updates, like local mutations or load bundles.
  cache,
}

enum ServerTimestampBehavior {
  /// Return null for [FieldValue.serverTimestamp()] values that have not yet
  none,

  /// Return local estimates for [FieldValue.serverTimestamp()] values that have not yet been set to their final value.
  estimate,

  /// Return the previous value for [FieldValue.serverTimestamp()] values that have not yet been set to their final value.
  previous,
}

/// [AggregateSource] represents the source of data for an [AggregateQuery].
enum AggregateSource {
  /// Indicates that the data should be retrieved from the server.
  server,
}

/// [PersistenceCacheIndexManagerRequest] represents the request types for the persistence cache index manager.
enum PersistenceCacheIndexManagerRequest {
  enableIndexAutoCreation,
  disableIndexAutoCreation,
  deleteAllIndexes
}

class GetOptions {
  const GetOptions({
    required this.source,
    required this.serverTimestampBehavior,
  });

  final Source source;
  final ServerTimestampBehavior serverTimestampBehavior;
}

enum TransactionResult {
  success,
  failure,
}

enum TransactionType {
  get,
  update,
  set,
  // To prevent collide on C++ side, we use `deleteType` instead of `delete`.
  deleteType,
}

class DocumentOption {
  const DocumentOption({
    required this.merge,
    required this.mergeFields,
  });

  final bool? merge;
  final List<List<String?>?>? mergeFields;
}

class TransactionCommand {
  const TransactionCommand({
    required this.type,
    required this.path,
    required this.data,
    this.option,
  });

  final TransactionType type;
  final String path;
  final Map<Object?, Object?>? data;
  final DocumentOption? option;
}

class DocumentReferenceRequest {
  const DocumentReferenceRequest({
    required this.path,
    this.data,
    this.option,
    this.source,
    this.serverTimestampBehavior,
  });
  final String path;
  final Map<Object?, Object?>? data;
  final DocumentOption? option;
  final Source? source;
  final ServerTimestampBehavior? serverTimestampBehavior;
}

class QueryParameters {
  const QueryParameters({
    this.where,
    this.orderBy,
    this.limit,
    this.startAt,
    this.startAfter,
    this.endAt,
    this.endBefore,
    this.limitToLast,
    this.filters,
  });

  final List<List<Object?>?>? where;
  final List<List<Object?>?>? orderBy;
  final int? limit;
  final int? limitToLast;
  final List<Object?>? startAt;
  final List<Object?>? startAfter;
  final List<Object?>? endAt;
  final List<Object?>? endBefore;
  final Map<String?, Object?>? filters;
}

enum AggregateType {
  count,
  sum,
  average,
}

class AggregateQuery {
  const AggregateQuery({
    required this.type,
    required this.field,
  });

  final AggregateType type;
  final String? field;
}

class AggregateQueryResponse {
  const AggregateQueryResponse({
    required this.type,
    required this.value,
    required this.field,
  });

  final AggregateType type;
  final String? field;
  final double? value;
}

@HostApi(dartHostTestHandler: 'TestFirebaseFirestoreHostApi')
abstract class FirebaseFirestoreHostApi {
  @async
  String loadBundle(
    FirestoreFirebaseApp app,
    Uint8List bundle,
  );

  @async
  QuerySnapshot namedQueryGet(
    FirestoreFirebaseApp app,
    String name,
    GetOptions options,
  );

  @async
  void clearPersistence(
    FirestoreFirebaseApp app,
  );

  @async
  void disableNetwork(
    FirestoreFirebaseApp app,
  );

  @async
  void enableNetwork(
    FirestoreFirebaseApp app,
  );

  @async
  void terminate(
    FirestoreFirebaseApp app,
  );

  @async
  void waitForPendingWrites(
    FirestoreFirebaseApp app,
  );

  @async
  void setIndexConfiguration(
    FirestoreFirebaseApp app,
    String indexConfiguration,
  );

  @async
  void setLoggingEnabled(
    bool loggingEnabled,
  );

  @async
  String snapshotsInSyncSetup(
    FirestoreFirebaseApp app,
  );

  @async
  String transactionCreate(
    FirestoreFirebaseApp app,
    int timeout,
    int maxAttempts,
  );

  @async
  void transactionStoreResult(
    String transactionId,
    TransactionResult resultType,
    List<TransactionCommand?>? commands,
  );

  @async
  DocumentSnapshot transactionGet(
    FirestoreFirebaseApp app,
    String transactionId,
    String path,
  );

  @async
  void documentReferenceSet(
    FirestoreFirebaseApp app,
    DocumentReferenceRequest request,
  );

  @async
  void documentReferenceUpdate(
    FirestoreFirebaseApp app,
    DocumentReferenceRequest request,
  );

  @async
  DocumentSnapshot documentReferenceGet(
    FirestoreFirebaseApp app,
    DocumentReferenceRequest request,
  );

  @async
  void documentReferenceDelete(
    FirestoreFirebaseApp app,
    DocumentReferenceRequest request,
  );

  @async
  QuerySnapshot queryGet(
    FirestoreFirebaseApp app,
    String path,
    bool isCollectionGroup,
    QueryParameters parameters,
    GetOptions options,
  );

  @async
  List<AggregateQueryResponse?> aggregateQuery(
    FirestoreFirebaseApp app,
    String path,
    QueryParameters parameters,
    AggregateSource source,
    List<AggregateQuery?> queries,
    bool isCollectionGroup,
  );

  @async
  void writeBatchCommit(
    FirestoreFirebaseApp app,
    List<TransactionCommand?> writes,
  );

  @async
  String querySnapshot(
    FirestoreFirebaseApp app,
    String path,
    bool isCollectionGroup,
    QueryParameters parameters,
    GetOptions options,
    bool includeMetadataChanges,
    ListenSource source,
  );

  @async
  String documentReferenceSnapshot(
    FirestoreFirebaseApp app,
    DocumentReferenceRequest parameters,
    bool includeMetadataChanges,
    ListenSource source,
  );

  @async
  void persistenceCacheIndexManagerRequest(
    FirestoreFirebaseApp app,
    PersistenceCacheIndexManagerRequest request,
  );
}
