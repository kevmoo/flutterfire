// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:_flutterfire_internals/_flutterfire_internals.dart';

/// Will return a [FirebaseException] from a thrown web error.
/// Any other errors will be propagated as normal.
Future<R> convertWebExceptions<R>(FutureOr<R> Function() cb) {
  return guardWebExceptions(
    () async => cb(),
    plugin: 'firebase_app_check',
  );
}

/// A synchronous version of [convertWebExceptions] for [Stream]s.
Stream<R> convertWebStreamExceptions<R>(
  Stream<R> Function() action,
) {
  try {
    return action().handleError((Object error, StackTrace stackTrace) {
      convertPlatformExceptionToFirebaseException(
        error,
        stackTrace,
        plugin: 'firebase_app_check',
      );
    });
  } catch (error, stackTrace) {
    convertPlatformExceptionToFirebaseException(
      error,
      stackTrace,
      plugin: 'firebase_app_check',
    );
  }
}
