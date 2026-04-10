// ignore_for_file: require_trailing_commas
// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_flutterfire_internals/_flutterfire_internals.dart';

Future<R> convertWebExceptions<R>(
  FutureOr<R> Function() action, {
  String plugin = 'firebase_analytics',
}) {
  return guardWebExceptions(
    () async => action(),
    plugin: plugin,
  );
}
