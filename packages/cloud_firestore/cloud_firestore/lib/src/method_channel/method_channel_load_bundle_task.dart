part of cloud_firestore;
// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: require_trailing_commas

class MethodChannelLoadBundleTask extends LoadBundleTaskPlatform {
  MethodChannelLoadBundleTask({
    required Future<String?> task,
  }) : super() {
    Stream<LoadBundleTaskSnapshotPlatform> mapNativeStream() async* {
      final observerId = await task;

      final nativePlatformStream =
          MethodChannelFirebaseFirestore.loadBundleChannel(observerId!)
              .receiveBroadcastStream();
      try {
        await for (final snapshot in nativePlatformStream) {
          final taskState = convertToTaskState(snapshot['taskState']);

          yield LoadBundleTaskSnapshotPlatform(
              taskState, Map<String, dynamic>.from(snapshot));

          if (taskState == LoadBundleTaskState.success) {
            // this will close the stream and stop listening to nativePlatformStream
            return;
          }
        }
      } catch (exception) {
        // TODO this should be refactored to use `convertPlatformException`,
        // then change receiveBroadcastStream -> receiveGuardedBroadedStream
        if (exception is! Exception || exception is! PlatformException) {
          rethrow;
        }

        Map<String, String>? details = exception.details != null
            ? Map<String, String>.from(exception.details)
            : null;

        throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'load-bundle-error',
            message: details?['message'] ?? '');
      }
    }

    stream = mapNativeStream().asBroadcastStream(
        onListen: (sub) => sub.resume(), onCancel: (sub) => sub.pause());
  }

  @override
  late final Stream<LoadBundleTaskSnapshotPlatform> stream;
}
