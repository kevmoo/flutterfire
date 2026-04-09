// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';

/// Implementation for a [ListResultPlatform].
class RestListResult extends ListResultPlatform {
  /// Create an instance of [RestListResult].
  RestListResult(
    FirebaseStoragePlatform storage, {
    String? nextPageToken,
    List<String>? items,
    List<String>? prefixes,
  })  : _items = items ?? [],
        _prefixes = prefixes ?? [],
        super(storage, nextPageToken);

  final List<String> _items;
  final List<String> _prefixes;

  @override
  List<ReferencePlatform> get items {
    return _items.map((path) => storage!.ref(path)).toList();
  }

  @override
  List<ReferencePlatform> get prefixes {
    return _prefixes.map((path) => storage!.ref(path)).toList();
  }
}
