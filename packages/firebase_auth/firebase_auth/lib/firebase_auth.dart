// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_auth;

import 'dart:async';

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
// We need to import the internal platform interface classes because we moved the method channel implementations here
import 'package:firebase_auth_platform_interface/src/platform_interface/platform_interface_auth.dart';
import 'package:firebase_auth_platform_interface/src/platform_interface/platform_interface_user.dart';
import 'package:firebase_auth_platform_interface/src/platform_interface/platform_interface_user_credential.dart';
import 'package:firebase_auth_platform_interface/src/platform_interface/platform_interface_multi_factor.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:_flutterfire_internals/_flutterfire_internals.dart';

export 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'
    show
        FirebaseAuthException,
        MultiFactorInfo,
        MultiFactorSession,
        PhoneMultiFactorInfo,
        TotpMultiFactorInfo,
        IdTokenResult,
        UserMetadata,
        UserInfo,
        ActionCodeInfo,
        ActionCodeSettings,
        AdditionalUserInfo,
        Persistence,
        PhoneVerificationCompleted,
        PhoneVerificationFailed,
        PhoneCodeSent,
        PhoneCodeAutoRetrievalTimeout,
        AuthCredential,
        AuthProvider,
        AppleAuthProvider,
        AppleFullPersonName,
        AppleAuthCredential,
        EmailAuthProvider,
        EmailAuthCredential,
        FacebookAuthProvider,
        FacebookAuthCredential,
        GameCenterAuthProvider,
        GameCenterAuthCredential,
        PlayGamesAuthProvider,
        PlayGamesAuthCredential,
        GithubAuthProvider,
        GithubAuthCredential,
        GoogleAuthProvider,
        GoogleAuthCredential,
        YahooAuthProvider,
        YahooAuthCredential,
        MicrosoftAuthProvider,
        OAuthProvider,
        OAuthCredential,
        PhoneAuthProvider,
        PhoneAuthCredential,
        SAMLAuthProvider,
        TwitterAuthProvider,
        TwitterAuthCredential,
        RecaptchaVerifierOnSuccess,
        RecaptchaVerifierOnExpired,
        RecaptchaVerifierOnError,
        RecaptchaVerifierSize,
        RecaptchaVerifierTheme,
        PasswordValidationStatus;
export 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebaseException;

part 'src/confirmation_result.dart';
part 'src/firebase_auth.dart';
part 'src/multi_factor.dart';
part 'src/recaptcha_verifier.dart';
part 'src/user.dart';
part 'src/user_credential.dart';
part 'src/method_channel/method_channel_user.dart';
part 'src/method_channel/method_channel_user_credential.dart';
part 'src/method_channel/method_channel_multi_factor.dart';
part 'src/method_channel/method_channel_firebase_auth.dart';
part 'src/method_channel/utils/convert_auth_provider.dart';
part 'src/method_channel/utils/event_channel.dart';
part 'src/method_channel/utils/exception.dart';
part 'src/method_channel/utils/phone_auth_callbacks.dart';
part 'src/method_channel/utils/pigeon_helper.dart';
part 'src/method_channel/utils/web_utils.dart';
part 'src/pigeon/messages.pigeon.dart';
part 'src/pigeon/test_api.dart';
