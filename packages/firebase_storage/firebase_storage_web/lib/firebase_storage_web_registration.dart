// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';

import 'src/firebase_storage_web.dart';

/// The registration class for [FirebaseStorageWeb].
class FirebaseStorageWebRegistration {
  static const String _libraryName = 'flutter-fire-gcs';

  /// Called by PluginRegistry to register this plugin for Flutter Web.
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('storage');
    FirebaseStoragePlatform.instance = FirebaseStorageWeb.nullInstance();
  }
}
