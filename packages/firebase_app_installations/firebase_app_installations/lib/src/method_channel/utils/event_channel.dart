part of firebase_app_installations;
// ignore_for_file: require_trailing_commas
// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A custom [EventChannel] with default error handling logic.
///
/// This uses dynamic access to avoid a hard dependency on the Flutter SDK.
extension EventChannelExtension on dynamic {
  /// Similar to [receiveBroadcastStream], but with enforced error handling.
  Stream<dynamic> receiveGuardedBroadcastStream({
    dynamic arguments,
    required dynamic Function(Object error, StackTrace stackTrace) onError,
  }) {
    final incomingStackTrace = StackTrace.current;

    return this.receiveBroadcastStream(arguments).handleError((Object error) {
      // TODO(rrousselGit): use package:stack_trace to merge the error's StackTrace with "incomingStackTrace"
      // This TODO assumes that EventChannel is updated to actually pass a StackTrace
      // (as it currently only sends StackTrace.empty)
      return onError(error, incomingStackTrace);
    });
  }
}
