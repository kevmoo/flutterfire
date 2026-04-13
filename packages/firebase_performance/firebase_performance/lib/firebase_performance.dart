// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_performance;

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;
export 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart'
    show HttpMethod;

part 'src/firebase_performance.dart';
part 'src/http_metric.dart';
part 'src/trace.dart';
part 'src/method_channel/method_channel_firebase_performance.dart';
part 'src/method_channel/method_channel_http_metric.dart';
part 'src/method_channel/method_channel_trace.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
part 'src/pigeon/test_api.dart';
