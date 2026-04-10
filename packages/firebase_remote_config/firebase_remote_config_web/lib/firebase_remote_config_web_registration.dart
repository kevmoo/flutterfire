// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';

import 'firebase_remote_config_web.dart';

/// The registration class for [FirebaseRemoteConfigWeb].
class FirebaseRemoteConfigWebRegistration {
  static const String _libraryName = 'flutter-fire-rc';

  /// Create the default instance of the [FirebaseRemoteConfigPlatform] as a [FirebaseRemoteConfigWeb]
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService(
      'remote-config',
      productNameOverride: 'remote_config',
    );
    FirebaseRemoteConfigPlatform.instance = FirebaseRemoteConfigWeb.instance;
  }
}
