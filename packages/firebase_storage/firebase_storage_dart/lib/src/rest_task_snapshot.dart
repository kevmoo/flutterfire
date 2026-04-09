// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';

/// Implementation for a [TaskSnapshotPlatform].
class RestTaskSnapshot extends TaskSnapshotPlatform {
  /// Create an instance of [RestTaskSnapshot].
  RestTaskSnapshot(this.storage, TaskState state, Map<String, dynamic> data)
      : _snapshotData = data,
        super(state, data);

  /// The storage service associated with this snapshot.
  final FirebaseStoragePlatform storage;

  final Map<String, dynamic> _snapshotData;

  @override
  ReferencePlatform get ref {
    return storage.ref((_snapshotData['path'] as String?) ?? '/');
  }
}
