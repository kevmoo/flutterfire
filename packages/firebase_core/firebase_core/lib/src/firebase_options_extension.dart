// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../firebase_core.dart';

/// Extension for [FirebaseOptions] to handle Pigeon-specific logic.
extension FirebaseOptionsExtension on FirebaseOptions {
  /// Create [FirebaseOptions] from a [CoreFirebaseOptions] Pigeon object.
  static FirebaseOptions fromPigeon(CoreFirebaseOptions options) {
    return FirebaseOptions(
      apiKey: options.apiKey,
      appId: options.appId,
      messagingSenderId: options.messagingSenderId,
      projectId: options.projectId,
      authDomain: options.authDomain,
      databaseURL: options.databaseURL,
      storageBucket: options.storageBucket,
      measurementId: options.measurementId,
      trackingId: options.trackingId,
      deepLinkURLScheme: options.deepLinkURLScheme,
      androidClientId: options.androidClientId,
      iosClientId: options.iosClientId,
      iosBundleId: options.iosBundleId,
      appGroupId: options.appGroupId,
    );
  }
}
