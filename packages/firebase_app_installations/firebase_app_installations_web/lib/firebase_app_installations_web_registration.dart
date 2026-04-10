// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_app_installations_platform_interface/firebase_app_installations_platform_interface.dart';

import 'firebase_app_installations_web.dart';

/// The registration class for [FirebaseAppInstallationsWeb].
class FirebaseAppInstallationsWebRegistration {
  static const String _libraryName = 'flutter-fire-installations';

  /// Create the default instance of the [FirebaseAppInstallationsPlatform] as a [FirebaseAppInstallationsWeb]
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);
    FirebaseCoreWeb.registerService('installations');
    FirebaseAppInstallationsPlatform.instance =
        FirebaseAppInstallationsWeb.instance;
  }
}
