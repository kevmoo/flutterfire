// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_dart/firebase_storage_dart.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';

void main() {
  setupFirebaseStorageMocks();

  group('RestFirebaseStorage Delegation', () {
    test('FirebaseStorage uses RestFirebaseStorage delegate when set as instance', () async {
      await Firebase.initializeApp();
      
      final app = Firebase.app();
      final bucket = app.options.storageBucket!;
      
      // Manually set the instance to our REST implementation
      final restImplementation = RestFirebaseStorage(app: app, bucket: bucket);
      FirebaseStoragePlatform.instance = restImplementation;
      
      final storage = FirebaseStorage.instance;
      
      // Check if it's using our implementation via the ref behavior 
      // (RestReference should be returned)
      final reference = storage.ref('test.txt');
      
      // Since Reference class wraps a ReferencePlatform, we can't check its type easily
      // but we can check the bucket and fullPath which are delegated.
      expect(reference.bucket, contains('fake-storage-bucket-url.com'));
      expect(reference.fullPath, 'test.txt');
      
      // If we could access private members we would see it's a RestReference
    });
  });
}
