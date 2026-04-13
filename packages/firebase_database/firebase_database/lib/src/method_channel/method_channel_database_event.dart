part of firebase_database;
// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class MethodChannelDatabaseEvent extends DatabaseEventPlatform {
  MethodChannelDatabaseEvent(this._ref, this._data) : super(_data);

  DatabaseReferencePlatform _ref;

  Map<String, dynamic> _data;

  @override
  DataSnapshotPlatform get snapshot {
    return MethodChannelDataSnapshot(_ref, Map.from(_data['snapshot']));
  }
}
