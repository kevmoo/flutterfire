part of '../firebase_auth.dart';
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Returns the origin name for a given [appName].
String getOriginName(String appName) {
  return '$appName-firebaseEmulatorOrigin';
}
