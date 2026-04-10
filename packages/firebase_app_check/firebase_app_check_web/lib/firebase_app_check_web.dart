// ignore_for_file: require_trailing_commas
// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';

import 'package:firebase_app_check_platform_interface/firebase_app_check_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart' as core_interop;

import 'src/interop/app_check.dart' as app_check_interop;
import 'src/internals.dart';

/// Web implementation of [FirebaseAppCheckPlatform].
class FirebaseAppCheckWeb extends FirebaseAppCheckPlatform {
  /// The entry point for the [FirebaseAppCheckWeb] class.
  FirebaseAppCheckWeb({required FirebaseApp app}) : super(appInstance: app);

  app_check_interop.AppCheck? _webAppCheck;

  app_check_interop.AppCheck? get _delegate {
    return _webAppCheck;
  }

  static final Map<String, StreamController<String?>> _tokenChangesListeners =
      {};

  @override
  Future<void> activate({
    WebProvider? webProvider,
    @Deprecated(
      'Use providerAndroid instead. '
      'This parameter will be removed in a future major release.',
    )
    AndroidProvider? androidProvider,
    @Deprecated(
      'Use providerApple instead. '
      'This parameter will be removed in a future major release.',
    )
    AppleProvider? appleProvider,
    AndroidAppCheckProvider? providerAndroid,
    AppleAppCheckProvider? providerApple,
    WindowsAppCheckProvider? providerWindows,
  }) async {
    // activate API no longer exists, recaptcha key has to be passed on initialization of app-check instance.
    return convertWebExceptions(() async {
      _webAppCheck ??= app_check_interop.getAppCheckInstance(
        core_interop.app(app.name),
        webProvider,
      );
      _initialiseStreamController();
    });
  }

  void _initialiseStreamController() {
    if (_tokenChangesListeners[app.name] == null) {
      _tokenChangesListeners[app.name] = StreamController<String?>.broadcast(
        onCancel: () {
          _tokenChangesListeners[app.name]!.close();
          _tokenChangesListeners.remove(app.name);
          _delegate!.idTokenChangedController?.close();
        },
      );
      _delegate!
          .onTokenChanged(app.name)
          .listen(
            (event) {
              _tokenChangesListeners[app.name]!.add(event.token.toDart);
            },
            // Forward JS SDK errors (e.g. network failures during background
            // token refresh) to the broadcast controller instead of letting them
            // surface as unhandled zone errors. If nobody is listening on the
            // broadcast stream the error is silently dropped.
            onError: (Object error) {
              _tokenChangesListeners[app.name]?.addError(error);
            },
          );
    }
  }

  @override
  Future<String?> getToken(bool forceRefresh) async {
    return convertWebExceptions(() async {
      app_check_interop.AppCheckTokenResultJsImpl result = await _delegate!
          .getToken(forceRefresh);
      return result.token.toDart;
    });
  }

  @override
  Future<String> getLimitedUseToken() async {
    return convertWebExceptions(() async {
      app_check_interop.AppCheckTokenResultJsImpl result = await _delegate!
          .getLimitedUseToken();
      return result.token.toDart;
    });
  }

  @override
  Future<void> setTokenAutoRefreshEnabled(
    bool isTokenAutoRefreshEnabled,
  ) async {
    return convertWebExceptions(
      () async =>
          _delegate!.setTokenAutoRefreshEnabled(isTokenAutoRefreshEnabled),
    );
  }

  @override
  Stream<String?> get onTokenChange {
    _initialiseStreamController();
    return convertWebStreamExceptions(() => _tokenChangesListeners[app.name]!.stream);
  }
}
