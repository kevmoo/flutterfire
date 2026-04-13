// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_database;

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database_platform_interface/firebase_database_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;
export 'package:firebase_database_platform_interface/firebase_database_platform_interface.dart'
    show
        DatabaseEventType,
        ServerValue,
        Transaction;

part 'src/data_snapshot.dart';
part 'src/database_event.dart';
part 'src/database_reference.dart';
part 'src/firebase_database.dart';
part 'src/on_disconnect.dart';
part 'src/query.dart';
part 'src/transaction_result.dart';
part 'src/method_channel/method_channel_data_snapshot.dart';
part 'src/method_channel/method_channel_database.dart';
part 'src/method_channel/method_channel_database_event.dart';
part 'src/method_channel/method_channel_database_reference.dart';
part 'src/method_channel/method_channel_on_disconnect.dart';
part 'src/method_channel/method_channel_query.dart';
part 'src/method_channel/method_channel_transaction_result.dart';
part 'src/method_channel/utils/push_id_generator.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
part 'src/pigeon/test_api.dart';
