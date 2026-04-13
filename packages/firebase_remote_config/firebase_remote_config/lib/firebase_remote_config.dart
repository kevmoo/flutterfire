// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library firebase_remote_config;

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;
export 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart'
    show
        RemoteConfigSettings,
        RemoteConfigUpdate,
        RemoteConfigValue,
        ValueSource;

part 'src/firebase_remote_config.dart';
part 'src/method_channel/method_channel_firebase_remote_config.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
