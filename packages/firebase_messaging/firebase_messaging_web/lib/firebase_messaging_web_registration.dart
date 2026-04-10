// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

import 'firebase_messaging_web.dart';

/// The registration class for [FirebaseMessagingWeb].
class FirebaseMessagingWebRegistration {
  static const String _libraryName = 'flutter-fire-fcm';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('messaging');
    FirebaseMessagingPlatform.instance = FirebaseMessagingWeb();
  }
}
