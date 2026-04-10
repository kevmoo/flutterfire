// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/src/pigeon/messages.pigeon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseOptionsExtension', () {
    test('should construct an instance from a Pigeon class', () {
      FirebaseOptions options1 = FirebaseOptionsExtension.fromPigeon(
        CoreFirebaseOptions(
          apiKey: 'apiKey',
          appId: 'appId',
          messagingSenderId: 'messagingSenderId',
          projectId: 'projectId',
        ),
      );

      FirebaseOptions options2 = const FirebaseOptions(
        apiKey: 'apiKey',
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId: 'projectId',
      );

      expect(options1, options2);
    });
  });
}
