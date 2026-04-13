// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_storage;

import 'dart:async';
import 'dart:convert' show utf8, base64;
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;
export 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart'
    show
        ListOptions,
        FullMetadata,
        SettableMetadata,
        PutStringFormat,
        TaskState;

part 'src/firebase_storage.dart';
part 'src/list_result.dart';
part 'src/reference.dart';
part 'src/task.dart';
part 'src/task_snapshot.dart';
part 'src/utils.dart';
part 'src/method_channel/method_channel_firebase_storage.dart';
part 'src/method_channel/method_channel_list_result.dart';
part 'src/method_channel/method_channel_reference.dart';
part 'src/method_channel/method_channel_task.dart';
part 'src/method_channel/method_channel_task_snapshot.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
part 'src/pigeon/test_api.dart';
