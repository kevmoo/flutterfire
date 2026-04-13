// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_auth;

/// The MethodChannel implementation of [MultiFactorPlatform].
class MethodChannelMultiFactor extends MultiFactorPlatform {
  MethodChannelMultiFactor(this._auth);

  final MethodChannelFirebaseAuth _auth;

  @override
  Future<void> enroll(
    MultiFactorAssertionPlatform assertion, [
    String? displayName,
  ]) async {
    try {
      final MethodChannelMultiFactorAssertion methodChannelAssertion =
          assertion as MethodChannelMultiFactorAssertion;
      await _api.userEnrollMultiFactor(
        _auth.pigeonDefault,
        methodChannelAssertion._assertion,
        displayName,
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<List<MultiFactorInfo>> getEnrolledFactors() async {
    try {
      final List<Object?> result =
          await _api.userGetEnrolledMultiFactors(_auth.pigeonDefault);
      return result
          .map((e) => MultiFactorInfo.fromMap(Map<String, dynamic>.from(e! as Map)))
          .toList();
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<MultiFactorSession> getSession() async {
    try {
      final result = await _api.userGetMultiFactorSession(_auth.pigeonDefault);
      return MultiFactorSession(result.id);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> unenroll({
    String? factorId,
    MultiFactorInfo? multiFactorInfo,
  }) async {
    try {
      await _api.userUnenrollMultiFactor(
        _auth.pigeonDefault,
        factorId,
        multiFactorInfo?.uid,
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }
}

/// The MethodChannel implementation of [MultiFactorAssertionPlatform].
class MethodChannelMultiFactorAssertion extends MultiFactorAssertionPlatform {
  final FirebaseAuthHostApi _api = FirebaseAuthHostApi();

  final MethodChannelFirebaseAuth _auth;

  final PigeonMultiFactorAssertion _assertion;

  MethodChannelMultiFactorAssertion(this._auth, this._assertion);

  @override
  Future<UserCredentialPlatform> getAssertion() async {
    try {
      final result = await _api.getAssertion(_auth.pigeonDefault, _assertion);
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }
}

/// The MethodChannel implementation of [PhoneMultiFactorGeneratorPlatform].
class MethodChannelPhoneMultiFactorGenerator
    extends PhoneMultiFactorGeneratorPlatform {
  @override
  MultiFactorAssertionPlatform getAssertion(
    PhoneAuthCredential credential,
  ) {
    // Note: This logic might need to wrap the credential into a PigeonMultiFactorAssertion
    throw UnimplementedError();
  }
}

/// The MethodChannel implementation of [TotpMultiFactorGeneratorPlatform].
class MethodChannelTotpMultiFactorGenerator
    extends TotpMultiFactorGeneratorPlatform {
  final FirebaseAuthHostApi _api = FirebaseAuthHostApi();

  @override
  Future<MultiFactorAssertionPlatform> getAssertionForEnrollment(
    TotpSecretPlatform secret,
    String smsCode,
  ) async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<MultiFactorAssertionPlatform> getAssertionForSignIn(
    String enrollmentId,
    String smsCode,
  ) async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<TotpSecretPlatform> generateSecret(MultiFactorSession session) async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<void> openInOtpApp(
    String qrCodeUrl, {
    String? otpAppName,
  }) async {
    try {
      await _api.openInOtpApp(qrCodeUrl, otpAppName);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  String generateQrCodeUrl(
    String accountName,
    String secretKey, {
    String? issuer,
  }) {
    return 'otpauth://totp/$issuer:$accountName?secret=$secretKey&issuer=$issuer';
  }
}
