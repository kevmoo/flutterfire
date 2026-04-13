// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library cloud_firestore;

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

export 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart'
    show
        FieldPath,
        FirebaseFirestoreException,
        Settings,
        GetOptions,
        Source,
        ServerTimestampBehavior,
        DocumentSnapshotPlatform,
        QuerySnapshotPlatform,
        ListSource,
        LoadBundleTaskState,
        SetOptions,
        DocumentChangeType,
        ListenSource,
        AggregateSource,
        AggregateQuerySnapshot,
        AggregateField,
        SumAggregateField,
        AverageAggregateField,
        CountAggregateField,
        VectorValue;
export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;

part 'src/collection_reference.dart';
part 'src/document_reference.dart';
part 'src/document_snapshot.dart';
part 'src/field_value.dart';
part 'src/filters.dart';
part 'src/firestore.dart';
part 'src/load_bundle_task_snapshot.dart';
part 'src/query.dart';
part 'src/query_document_snapshot.dart';
part 'src/query_snapshot.dart';
part 'src/snapshot_metadata.dart';
part 'src/transaction.dart';
part 'src/write_batch.dart';
part 'src/utils/codec_utility.dart';
part 'src/method_channel/method_channel_aggregate_query.dart';
part 'src/method_channel/method_channel_collection_reference.dart';
part 'src/method_channel/method_channel_document_change.dart';
part 'src/method_channel/method_channel_document_reference.dart';
part 'src/method_channel/method_channel_field_value.dart';
part 'src/method_channel/method_channel_field_value_factory.dart';
part 'src/method_channel/method_channel_firestore.dart';
part 'src/method_channel/method_channel_load_bundle_task.dart';
part 'src/method_channel/method_channel_persistent_cache_index_manager.dart';
part 'src/method_channel/method_channel_query.dart';
part 'src/method_channel/method_channel_query_snapshot.dart';
part 'src/method_channel/method_channel_transaction.dart';
part 'src/method_channel/method_channel_write_batch.dart';
part 'src/method_channel/utils/auto_id_generator.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/firestore_message_codec.dart';
part 'src/method_channel/utils/maps.dart';
part 'src/method_channel/utils/source.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/pigeon/messages.pigeon.dart';
