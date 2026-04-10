// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:cloud_firestore_web/src/cloud_firestore_version.dart';

import 'cloud_firestore_web.dart';

/// The registration class for [FirebaseFirestoreWeb].
class FirebaseFirestoreWebRegistration {
  static const String _libraryName = 'flutter-fire-fst';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('firestore');
    FirebaseFirestorePlatform.instance = FirebaseFirestoreWeb();
  }
}
