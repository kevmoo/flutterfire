// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';

import 'firebase_analytics_web.dart';

/// The registration class for [FirebaseAnalyticsWeb].
class FirebaseAnalyticsWebRegistration {
  static const String _libraryName = 'flutter-fire-analytics';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService('analytics');
    FirebaseAnalyticsPlatform.instance = FirebaseAnalyticsWeb();
  }
}
