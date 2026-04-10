// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:_flutterfire_internals/_flutterfire_internals.dart';

Future<R> convertWebExceptions<R>(
  FutureOr<R> Function() action, {
  String plugin = 'cloud_firestore',
}) {
  return guardWebExceptions(
    () async => action(),
    plugin: plugin,
  );
}

/// A synchronous version of [convertWebExceptions] for [Stream]s.
Stream<R> convertWebStreamExceptions<R>(
  Stream<R> Function() action, {
  String plugin = 'cloud_firestore',
}) {
  try {
    return action().handleError((Object error, StackTrace stackTrace) {
      convertPlatformExceptionToFirebaseException(
        error,
        stackTrace,
        plugin: plugin,
      );
    });
  } catch (error, stackTrace) {
    convertPlatformExceptionToFirebaseException(
      error,
      stackTrace,
      plugin: plugin,
    );
  }
}
