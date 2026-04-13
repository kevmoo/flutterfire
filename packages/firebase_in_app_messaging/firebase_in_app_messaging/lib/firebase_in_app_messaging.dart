// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_in_app_messaging;

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_in_app_messaging_platform_interface/firebase_in_app_messaging_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;

part 'src/firebase_in_app_messaging.dart';
part 'src/method_channel/method_channel_firebase_in_app_messaging.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
