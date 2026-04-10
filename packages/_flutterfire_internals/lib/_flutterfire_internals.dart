// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: require_trailing_commas
// This file is NOT public.
// Moving it would break the imports
//
// This file exports utilities shared between firebase packages, without making
// them public.

import 'package:firebase_core_dart/firebase_core_dart.dart';

export 'src/exception.dart';

/// Returns a native Firebase App from a [FirebaseApp].
///
/// This uses dynamic access to avoid a hard dependency on web interop types
/// in the pure Dart platform interface.
dynamic getAppInterop(dynamic app) {
  // This is expected to be called only from web packages where
  // core_interop.getApp is available.
  throw UnimplementedError('getAppInterop() is web-only');
}

/// Returns a native Auth instance from a [FirebaseApp].
dynamic getAuthInterop(dynamic app) {
  throw UnimplementedError('getAuthInterop() is web-only');
}

/// A wrapper for any Firebase calls that may throw a native error.
///
/// It will catch the error and throw a [FirebaseException] instead.
Future<T> guardWebExceptions<T>(
  Future<T> Function() callback, {
  required String plugin,
  String? code,
}) async {
  try {
    return await callback();
  } catch (error, stack) {
    final dynamic e = error;
    // Check for properties commonly found on both PlatformException (mobile)
    // and FirebaseError (web).
    if (e != null && e is! FirebaseException) {
      String? errorCode;
      String? errorMessage;

      try {
        errorCode = e.code?.toString();
        errorMessage = e.message?.toString();
      } catch (_) {
        // Not a standard native error
      }

      if (errorCode != null || errorMessage != null) {
        throw FirebaseException(
          plugin: plugin,
          code: code ?? errorCode?.replaceFirst('auth/', '') ?? 'unknown',
          message: errorMessage ?? '',
          stackTrace: stack,
        );
      }
    }
    rethrow;
  }
}
