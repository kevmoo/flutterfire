// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_flutterfire_internals/_flutterfire_internals.dart';
import 'package:firebase_core_dart/firebase_core_dart.dart';
import 'package:test/test.dart';

void main() {
  group('guardWebExceptions', () {
    test(
      'preserves stacktrace on futures that fail with native error',
      () async {
        final current = StackTrace.current;
        try {
          await guardWebExceptions(
            () => Future.error(_NativeError('test-code', 'test-message'), current),
            plugin: 'test',
          );
          fail('dead code');
        } catch (err, stack) {
          expect(stack, current);
          expect(err, isA<FirebaseException>());
          final fe = err as FirebaseException;
          expect(fe.code, 'test-code');
          expect(fe.message, 'test-message');
        }
      },
    );

    test(
      'propagates plain Dart errors from Futures',
      () async {
        await expectLater(
          guardWebExceptions(
            () => Future<void>.error(ArgumentError('test')),
            plugin: 'test',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}

class _NativeError {
  _NativeError(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'NativeError($code, $message)';
}
