// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_database_platform_interface/firebase_database_platform_interface.dart';

import 'firebase_database_web.dart';

/// The registration class for [FirebaseDatabaseWeb].
class FirebaseDatabaseWebRegistration {
  static const String _libraryName = 'flutter-fire-rtdb';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('database');
    DatabasePlatform.instance = FirebaseDatabaseWeb();
  }
}
