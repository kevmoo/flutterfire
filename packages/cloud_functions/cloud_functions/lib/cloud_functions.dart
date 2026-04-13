// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library cloud_functions;

import 'dart:async';

import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart'
    show
        FirebaseFunctionsException,
        HttpsCallableOptions,
        HttpsCallableResult,
        HttpsCallableStreamResult;
export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;

part 'src/firebase_functions.dart';
part 'src/https_callable.dart';
part 'src/https_callable_result.dart';
part 'src/https_callable_stream_result.dart';
part 'src/method_channel/method_channel_firebase_functions.dart';
part 'src/method_channel/method_channel_https_callable.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
part 'src/pigeon/test_api.dart';
