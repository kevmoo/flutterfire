// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_auth_web/src/firebase_auth_version.dart';
import 'package:firebase_auth_web/src/firebase_auth_web_multi_factor.dart';
import 'package:firebase_auth_web/src/firebase_auth_web_recaptcha_verifier_factory.dart';
import 'package:firebase_auth_web/src/interop/auth.dart' as auth_interop;
import 'package:firebase_auth_web/src/utils/web_utils.dart';
import 'package:web/web.dart' as web;

import 'firebase_auth_web.dart';

const bool _kDebugMode = !bool.fromEnvironment('dart.vm.product');

/// The registration class for [FirebaseAuthWeb].
class FirebaseAuthWebRegistration {
  static const String _libraryName = 'flutter-fire-auth';

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebaseCoreWeb.registerLibraryVersion(_libraryName, packageVersion);

    FirebaseCoreWeb.registerService(
      'auth',
      ensurePluginInitialized: (firebaseApp) async {
        final authDelegate = auth_interop.getAuthInstance(firebaseApp);
        // if localhost, and emulator was previously set in localStorage, use it
        if (web.window.location.hostname == 'localhost' && _kDebugMode) {
          final String? emulatorOrigin = web.window.sessionStorage.getItem(
            getOriginName(firebaseApp.name),
          );

          if (emulatorOrigin != null) {
            try {
              authDelegate.useAuthEmulator(emulatorOrigin);
              // ignore: avoid_print
              print(
                'Using previously configured Auth emulator at $emulatorOrigin for ${firebaseApp.name} \nTo switch back to production, restart your app with the emulator turned off.',
              );
            } catch (e) {
              if (e.toString().contains('sooner')) {
                // Happens during hot reload when the emulator is already configured
                // ignore: avoid_print
                print(
                  'Auth emulator is already configured at $emulatorOrigin for ${firebaseApp.name} and kept across hot reload.\nTo switch back to production, restart your app with the emulator turned off.',
                );
              } else {
                rethrow;
              }
            }
          }
        }
        await authDelegate.onWaitInitState();
      },
    );
    FirebaseAuthPlatform.instance = FirebaseAuthWeb.instance;
    PhoneMultiFactorGeneratorPlatform.instance = PhoneMultiFactorGeneratorWeb();
    TotpMultiFactorGeneratorPlatform.instance = TotpMultiFactorGeneratorWeb();
    RecaptchaVerifierFactoryPlatform.instance =
        RecaptchaVerifierFactoryWeb.instance;
  }
}
