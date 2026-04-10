// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';

import 'firebase_performance_web.dart';

/// The registration class for [FirebasePerformanceWeb].
class FirebasePerformanceWebRegistration {
  static const String _libraryName = 'flutter-fire-perf';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('performance');
    FirebasePerformancePlatform.instance = FirebasePerformanceWeb.instance;
  }
}
