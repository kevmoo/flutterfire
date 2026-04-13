// ignore_for_file: require_trailing_commas
// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_storage;

import 'package:_flutterfire_internals/_flutterfire_internals.dart';

/// Catches a [PlatformException] and returns an [Exception].
///
/// If the [Exception] is a [PlatformException], a [FirebaseException] is returned.
Never convertPlatformException(Object exception, StackTrace stackTrace) {
  convertPlatformExceptionToFirebaseException(
    exception,
    stackTrace,
    plugin: 'firebase_storage',
  );
}

/// Catches a [PlatformException] and converts it into a [FirebaseException] if
/// it was intentionally caught on the native platform.
Future<T> catchFuturePlatformException<T>(
  Object exception,
  StackTrace stackTrace,
) {
  return Future<T>.error(
    catchPlatformExceptionToFirebaseException(
      exception,
      stackTrace,
      plugin: 'firebase_storage',
    ),
    stackTrace,
  );
}
