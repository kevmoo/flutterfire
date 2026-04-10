// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

import 'src/pigeon/messages.pigeon.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseOptions, defaultFirebaseAppName, FirebaseException;

part 'src/firebase.dart';
part 'src/firebase_app.dart';
part 'src/port_mapping.dart';
part 'src/firebase_options_extension.dart';
part 'src/method_channel/method_channel_firebase.dart';
part 'src/method_channel/method_channel_firebase_app.dart';
