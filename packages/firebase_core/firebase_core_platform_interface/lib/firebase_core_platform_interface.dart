// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The platform interface for Firebase Core.
library;

import 'dart:async';

import 'package:firebase_core_dart/firebase_core_dart.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'package:firebase_core_dart/firebase_core_dart.dart';

part 'src/firebase_core_exceptions.dart';
part 'src/platform_interface/platform_interface_firebase.dart';
part 'src/platform_interface/platform_interface_firebase_app.dart';
part 'src/platform_interface/platform_interface_firebase_plugin.dart';

/// The default Firebase application name.
const String defaultFirebaseAppName = '[DEFAULT]';
