// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_app_check_platform_interface/firebase_app_check_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_app_check_web.dart';

/// The registration class for [FirebaseAppCheckWeb].
class FirebaseAppCheckWebRegistration {
  /// Called by [FirebaseAppCheck.instance] to register the [FirebaseAppCheckWeb]
  /// plugin with the [FirebaseAppCheckPlatform] instance.
  static void registerWith(Registrar registrar) {
    FirebaseAppCheckPlatform.instance = FirebaseAppCheckWeb(app: Firebase.app());
  }
}
