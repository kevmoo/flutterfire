// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_core_dart/firebase_core_dart.dart';

/// Catches a native exception and returns a [FirebaseException] if possible.
///
/// This is pure Dart and does not depend on the Flutter SDK, but it can
/// handle native exceptions passed from Flutter (e.g. PlatformException)
/// by using dynamic property access.
Never convertPlatformExceptionToFirebaseException(
  Object exception,
  StackTrace rawStackTrace, {
  required String plugin,
}) {
  var stackTrace = rawStackTrace;
  if (stackTrace == StackTrace.empty) {
    stackTrace = StackTrace.current;
  }

  // We check for the existence of properties commonly found on PlatformException
  // without explicitly importing the Flutter SDK.
  final dynamic e = exception;
  final bool isPlatformException = _isPlatformException(e);

  if (!isPlatformException) {
    Error.throwWithStackTrace(exception, stackTrace);
  }

  Error.throwWithStackTrace(
    _platformExceptionToFirebaseException(e, plugin: plugin),
    stackTrace,
  );
}

bool _isPlatformException(dynamic e) {
  try {
    // PlatformException has a 'code' and 'message' property.
    return e.code != null && e is! FirebaseException;
  } catch (_) {
    return false;
  }
}

/// Converts a native exception into a [FirebaseException].
FirebaseException _platformExceptionToFirebaseException(
  dynamic platformException, {
  required String plugin,
}) {
  Map<String, Object>? details;

  final dynamic rawDetails = platformException.details;

  if (rawDetails is Map) {
    details = Map<String, Object>.from(rawDetails);
  }

  String? code;
  String message = platformException.message ?? '';

  if (details != null) {
    code = details['code'] as String?;
    message = details['message'] as String? ?? message;
  } else if (rawDetails != null) {
    message = rawDetails.toString();
  }

  return FirebaseException(
    plugin: plugin,
    code: code ?? 'unknown',
    message: message,
  );
}
