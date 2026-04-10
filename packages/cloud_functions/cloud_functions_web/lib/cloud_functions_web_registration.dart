// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart';

import 'cloud_functions_web.dart';

/// The registration class for [FirebaseFunctionsWeb].
class FirebaseFunctionsWebRegistration {
  static const String _libraryName = 'flutter-fire-functions';

  /// Create the default instance of the [FirebaseFunctionsPlatform] as a [FirebaseFunctionsWeb]
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('functions');
    FirebaseFunctionsPlatform.instance = FirebaseFunctionsWeb.instance;
  }
}
