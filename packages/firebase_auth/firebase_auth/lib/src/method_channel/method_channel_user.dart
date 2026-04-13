// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_auth;

/// An implementation of [UserPlatform] that uses [MethodChannel] to
/// communicate with Firebase plugins.
class MethodChannelUser extends UserPlatform {
  final FirebaseAuthHostApi _api = FirebaseAuthHostApi();

  /// Create a [MethodChannelUser] from a [UserDetails]
  MethodChannelUser(
    this._auth,
    this._multiFactor,
    UserDetails data,
  ) : super(_auth, _multiFactor, data);

  final MethodChannelFirebaseAuth _auth;
  final MethodChannelMultiFactor _multiFactor;

  @override
  Future<void> delete() async {
    try {
      await _api.userDelete(_auth.pigeonDefault);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async {
    try {
      return await _api.userIdToken(_auth.pigeonDefault, forceRefresh);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<IdTokenResultPlatform> getIdTokenResult([
    bool forceRefresh = false,
  ]) async {
    try {
      final result =
          await _api.userIdTokenResult(_auth.pigeonDefault, forceRefresh);
      return IdTokenResult(result.asMap());
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> linkWithCredential(
    AuthCredential credential,
  ) async {
    try {
      final result = await _api.userLinkWithCredential(
        _auth.pigeonDefault,
        credential.asMap(),
      );
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> linkWithProvider(AuthProvider provider) async {
    try {
      final convertedProvider = convertToOAuthProvider(provider);

      final result = await _api.userLinkWithProvider(
        _auth.pigeonDefault,
        PigeonSignInProvider(
          providerId: convertedProvider.providerId,
          scopes: convertedProvider is OAuthProvider
              ? convertedProvider.scopes
              : null,
          customParameters: convertedProvider is OAuthProvider
              ? convertedProvider.parameters
              : null,
        ),
      );
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> linkWithPopup(AuthProvider provider) async {
    throw UnimplementedError(
      'linkWithPopup() is only supported on web based platforms',
    );
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) async {
    throw UnimplementedError(
      'linkWithRedirect() is only supported on web based platforms',
    );
  }

  @override
  Future<UserCredentialPlatform> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    try {
      final result = await _api.userReauthenticateWithCredential(
        _auth.pigeonDefault,
        credential.asMap(),
      );
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> reauthenticateWithProvider(
    AuthProvider provider,
  ) async {
    try {
      final convertedProvider = convertToOAuthProvider(provider);

      final result = await _api.userReauthenticateWithProvider(
        _auth.pigeonDefault,
        PigeonSignInProvider(
          providerId: convertedProvider.providerId,
          scopes: convertedProvider is OAuthProvider
              ? convertedProvider.scopes
              : null,
          customParameters: convertedProvider is OAuthProvider
              ? convertedProvider.parameters
              : null,
        ),
      );
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> reauthenticateWithPopup(
    AuthProvider provider,
  ) async {
    throw UnimplementedError(
      'reauthenticateWithPopup() is only supported on web based platforms',
    );
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) async {
    throw UnimplementedError(
      'reauthenticateWithRedirect() is only supported on web based platforms',
    );
  }

  @override
  Future<void> reload() async {
    try {
      await _api.userReload(_auth.pigeonDefault);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> sendEmailVerification([
    ActionCodeSettings? actionCodeSettings,
  ]) async {
    try {
      await _api.userSendEmailVerification(
        _auth.pigeonDefault,
        actionCodeSettings == null
            ? null
            : PigeonActionCodeSettings(
                url: actionCodeSettings.url,
                handleCodeInApp: actionCodeSettings.handleCodeInApp,
                iOSBundleId: actionCodeSettings.iOSBundleId,
                androidPackageName: actionCodeSettings.androidPackageName,
                androidInstallApp: actionCodeSettings.androidInstallApp,
                androidMinimumVersion: actionCodeSettings.androidMinimumVersion,
                linkDomain: actionCodeSettings.linkDomain,
              ),
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> unlink(String providerId) async {
    try {
      final result = await _api.userUnlink(_auth.pigeonDefault, providerId);
      return MethodChannelUserCredential(_auth, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    try {
      await _api.userUpdateEmail(_auth.pigeonDefault, newEmail);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _api.userUpdatePassword(_auth.pigeonDefault, newPassword);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> updatePhoneNumber(AuthCredential credential) async {
    try {
      await _api.userUpdatePhoneNumber(_auth.pigeonDefault, credential.asMap());
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> updateDisplayName(String? displayName) async {
    try {
      await _api.userUpdateDisplayName(_auth.pigeonDefault, displayName);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> updatePhotoURL(String? photoURL) async {
    try {
      await _api.userUpdatePhotoURL(_auth.pigeonDefault, photoURL);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> verifyBeforeUpdateEmail(
    String newEmail, [
    ActionCodeSettings? actionCodeSettings,
  ]) async {
    try {
      await _api.userVerifyBeforeUpdateEmail(
        _auth.pigeonDefault,
        newEmail,
        actionCodeSettings == null
            ? null
            : PigeonActionCodeSettings(
                url: actionCodeSettings.url,
                handleCodeInApp: actionCodeSettings.handleCodeInApp,
                iOSBundleId: actionCodeSettings.iOSBundleId,
                androidPackageName: actionCodeSettings.androidPackageName,
                androidInstallApp: actionCodeSettings.androidInstallApp,
                androidMinimumVersion: actionCodeSettings.androidMinimumVersion,
                linkDomain: actionCodeSettings.linkDomain,
              ),
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }
}
