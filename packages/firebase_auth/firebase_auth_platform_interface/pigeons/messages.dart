// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: one_member_abstracts

import 'package:pigeon/pigeon.dart';

@Configure(
  Options(
    dartOut: 'lib/src/pigeon/messages.pigeon.dart',
    // We export in the lib folder to expose the class to other packages.
    dartTestOut: 'test/pigeon/test_api.dart',
    javaOut:
        '../firebase_auth/android/src/main/java/io/flutter/plugins/firebase/auth/GeneratedAndroidFirebaseAuth.java',
    javaOptions: JavaOptions(
      package: 'io.flutter.plugins.firebase.auth',
      className: 'GeneratedAndroidFirebaseAuth',
    ),
    objcHeaderOut:
        '../firebase_auth/ios/firebase_auth/Sources/firebase_auth/include/Public/firebase_auth_messages.g.h',
    objcSourceOut:
        '../firebase_auth/ios/firebase_auth/Sources/firebase_auth/firebase_auth_messages.g.m',
    cppHeaderOut: '../firebase_auth/windows/messages.g.h',
    cppSourceOut: '../firebase_auth/windows/messages.g.cpp',
    cppOptions: CppOptions(namespace: 'firebase_auth_windows'),
    copyrightHeader: 'pigeons/copyright.txt',
  ),
)
class MultiFactorSession {
  const MultiFactorSession({
    required this.id,
  });

  final String id;
}

class PhoneMultiFactorAssertion {
  const PhoneMultiFactorAssertion({
    required this.verificationId,
    required this.verificationCode,
  });

  final String verificationId;
  final String verificationCode;
}

class MultiFactorInfo {
  const MultiFactorInfo({
    this.displayName,
    required this.enrollmentTimestamp,
    this.factorId,
    required this.uid,
    required this.phoneNumber,
  });

  final String? displayName;
  final double enrollmentTimestamp;
  final String? factorId;
  final String uid;
  final String? phoneNumber;
}

// We prefix the class name with `Auth` to avoid a conflict with
// other classes in other packages.
class AuthFirebaseApp {
  const AuthFirebaseApp({
    required this.appName,
    required this.tenantId,
    required this.customAuthDomain,
  });

  final String appName;
  final String? tenantId;
  final String? customAuthDomain;
}

/// The type of operation that generated the action code from calling
/// [checkActionCode].
enum ActionCodeInfoOperation {
  /// Unknown operation.
  unknown,

  /// Password reset code generated via [sendPasswordResetEmail].
  passwordReset,

  /// Email verification code generated via [User.sendEmailVerification].
  verifyEmail,

  /// Email change revocation code generated via [User.updateEmail].
  recoverEmail,

  /// Email sign in code generated via [sendSignInLinkToEmail].
  emailSignIn,

  /// Verify and change email code generated via [User.verifyBeforeUpdateEmail].
  verifyAndChangeEmail,

  /// Action code for reverting second factor addition.
  revertSecondFactorAddition,
}

class ActionCodeInfoData {
  const ActionCodeInfoData({
    this.email,
    this.previousEmail,
  });

  final String? email;
  final String? previousEmail;
}

class ActionCodeInfo {
  const ActionCodeInfo({
    required this.operation,
    required this.data,
  });

  final ActionCodeInfoOperation operation;
  final ActionCodeInfoData data;
}

class AdditionalUserInfo {
  const AdditionalUserInfo({
    required this.isNewUser,
    required this.providerId,
    required this.username,
    this.profile,
    this.authorizationCode,
  });

  final bool isNewUser;
  final String? providerId;
  final String? username;
  final String? authorizationCode;
  final Map<String?, Object?>? profile;
}

class AuthCredential {
  const AuthCredential({
    required this.providerId,
    required this.signInMethod,
    required this.nativeId,
    required this.accessToken,
  });

  final String providerId;
  final String signInMethod;
  final int nativeId;
  final String? accessToken;
}

class UserInfo {
  const UserInfo({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.phoneNumber,
    required this.isAnonymous,
    required this.isEmailVerified,
    required this.tenantId,
    required this.providerId,
    required this.creationTimestamp,
    required this.lastSignInTimestamp,
    required this.refreshToken,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isAnonymous;
  final bool isEmailVerified;
  final String? providerId;
  final String? tenantId;
  final String? refreshToken;
  final int? creationTimestamp;
  final int? lastSignInTimestamp;
}

class UserDetails {
  const UserDetails({
    required this.userInfo,
    required this.providerData,
  });

  final UserInfo userInfo;
  final List<Map<Object?, Object?>?> providerData;
}

class UserCredential {
  const UserCredential({
    required this.user,
    required this.additionalUserInfo,
    required this.credential,
  });

  final UserDetails? user;
  final AdditionalUserInfo? additionalUserInfo;
  final AuthCredential? credential;
}

class AuthCredentialInput {
  const AuthCredentialInput({
    required this.providerId,
    required this.signInMethod,
    required this.token,
    required this.accessToken,
  });

  final String providerId;
  final String signInMethod;
  final String? token;
  final String? accessToken;
}

class ActionCodeSettings {
  const ActionCodeSettings({
    required this.url,
    required this.dynamicLinkDomain,
    required this.linkDomain,
    required this.handleCodeInApp,
    required this.iOSBundleId,
    required this.androidPackageName,
    required this.androidInstallApp,
    required this.androidMinimumVersion,
  });

  final String url;
  final String? dynamicLinkDomain;
  final bool handleCodeInApp;
  final String? iOSBundleId;
  final String? androidPackageName;
  final bool androidInstallApp;
  final String? androidMinimumVersion;
  final String? linkDomain;
}

class FirebaseAuthSettings {
  const FirebaseAuthSettings({
    required this.appVerificationDisabledForTesting,
    required this.userAccessGroup,
    required this.phoneNumber,
    required this.smsCode,
    required this.forceRecaptchaFlow,
  });

  final bool appVerificationDisabledForTesting;
  final String? userAccessGroup;
  final String? phoneNumber;
  final String? smsCode;
  final bool? forceRecaptchaFlow;
}

class SignInProvider {
  const SignInProvider({
    required this.providerId,
    required this.scopes,
    required this.customParameters,
  });

  final String providerId;
  final List<String?>? scopes;
  final Map<String?, String?>? customParameters;
}

class VerifyPhoneNumberRequest {
  const VerifyPhoneNumberRequest({
    required this.phoneNumber,
    required this.timeout,
    required this.forceResendingToken,
    required this.autoRetrievedSmsCodeForTesting,
    required this.multiFactorInfoId,
    required this.multiFactorSessionId,
  });

  final String? phoneNumber;
  final int timeout;
  final int? forceResendingToken;
  final String? autoRetrievedSmsCodeForTesting;
  final String? multiFactorInfoId;
  final String? multiFactorSessionId;
}

@HostApi(dartHostTestHandler: 'TestFirebaseAuthHostApi')
abstract class FirebaseAuthHostApi {
  @async
  String registerIdTokenListener(
    AuthFirebaseApp app,
  );

  @async
  String registerAuthStateListener(
    AuthFirebaseApp app,
  );

  @async
  void useEmulator(
    AuthFirebaseApp app,
    String host,
    int port,
  );

  @async
  void applyActionCode(
    AuthFirebaseApp app,
    String code,
  );

  @async
  ActionCodeInfo checkActionCode(
    AuthFirebaseApp app,
    String code,
  );

  @async
  void confirmPasswordReset(
    AuthFirebaseApp app,
    String code,
    String newPassword,
  );

  @async
  UserCredential createUserWithEmailAndPassword(
    AuthFirebaseApp app,
    String email,
    String password,
  );

  @async
  UserCredential signInAnonymously(
    AuthFirebaseApp app,
  );

  @async
  UserCredential signInWithCredential(
    AuthFirebaseApp app,
    Map<String, Object> input,
  );

  @async
  UserCredential signInWithCustomToken(
    AuthFirebaseApp app,
    String token,
  );

  @async
  UserCredential signInWithEmailAndPassword(
    AuthFirebaseApp app,
    String email,
    String password,
  );

  @async
  UserCredential signInWithEmailLink(
    AuthFirebaseApp app,
    String email,
    String emailLink,
  );

  @async
  UserCredential signInWithProvider(
    AuthFirebaseApp app,
    SignInProvider signInProvider,
  );

  @async
  void signOut(
    AuthFirebaseApp app,
  );

  @async
  List<String> fetchSignInMethodsForEmail(
    AuthFirebaseApp app,
    String email,
  );

  @async
  void sendPasswordResetEmail(
    AuthFirebaseApp app,
    String email,
    ActionCodeSettings? actionCodeSettings,
  );

  @async
  void sendSignInLinkToEmail(
    AuthFirebaseApp app,
    String email,
    ActionCodeSettings actionCodeSettings,
  );

  @async
  String setLanguageCode(
    AuthFirebaseApp app,
    String? languageCode,
  );

  @async
  void setSettings(
    AuthFirebaseApp app,
    FirebaseAuthSettings settings,
  );

  @async
  String verifyPasswordResetCode(
    AuthFirebaseApp app,
    String code,
  );

  @async
  String verifyPhoneNumber(
    AuthFirebaseApp app,
    VerifyPhoneNumberRequest request,
  );
  @async
  void revokeTokenWithAuthorizationCode(
    AuthFirebaseApp app,
    String authorizationCode,
  );

  @async
  void initializeRecaptchaConfig(
    AuthFirebaseApp app,
  );
}

class IdTokenResult {
  const IdTokenResult({
    required this.token,
    required this.expirationTimestamp,
    required this.authTimestamp,
    required this.issuedAtTimestamp,
    required this.signInProvider,
    required this.claims,
    required this.signInSecondFactor,
  });

  final String? token;
  final int? expirationTimestamp;
  final int? authTimestamp;
  final int? issuedAtTimestamp;
  final String? signInProvider;
  final Map<String?, Object?>? claims;
  final String? signInSecondFactor;
}

class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.photoUrl,
    required this.displayNameChanged,
    required this.photoUrlChanged,
  });

  final String? displayName;
  final String? photoUrl;
  final bool displayNameChanged;
  final bool photoUrlChanged;
}

@HostApi(dartHostTestHandler: 'TestFirebaseAuthUserHostApi')
abstract class FirebaseAuthUserHostApi {
  @async
  void delete(
    AuthFirebaseApp app,
  );

  @async
  IdTokenResult getIdToken(
    AuthFirebaseApp app,
    bool forceRefresh,
  );

  @async
  UserCredential linkWithCredential(
    AuthFirebaseApp app,
    Map<String, Object> input,
  );

  @async
  UserCredential linkWithProvider(
    AuthFirebaseApp app,
    SignInProvider signInProvider,
  );

  @async
  UserCredential reauthenticateWithCredential(
    AuthFirebaseApp app,
    Map<String, Object> input,
  );

  @async
  UserCredential reauthenticateWithProvider(
    AuthFirebaseApp app,
    SignInProvider signInProvider,
  );

  @async
  UserDetails reload(
    AuthFirebaseApp app,
  );

  @async
  void sendEmailVerification(
    AuthFirebaseApp app,
    ActionCodeSettings? actionCodeSettings,
  );

  @async
  UserCredential unlink(
    AuthFirebaseApp app,
    String providerId,
  );

  @async
  UserDetails updateEmail(
    AuthFirebaseApp app,
    String newEmail,
  );

  @async
  UserDetails updatePassword(
    AuthFirebaseApp app,
    String newPassword,
  );

  @async
  UserDetails updatePhoneNumber(
    AuthFirebaseApp app,
    Map<String, Object> input,
  );

  @async
  UserDetails updateProfile(
    AuthFirebaseApp app,
    UserProfile profile,
  );

  @async
  void verifyBeforeUpdateEmail(
    AuthFirebaseApp app,
    String newEmail,
    ActionCodeSettings? actionCodeSettings,
  );
}

@HostApi(dartHostTestHandler: 'TestMultiFactorUserHostApi')
abstract class MultiFactorUserHostApi {
  @async
  void enrollPhone(
    AuthFirebaseApp app,
    PhoneMultiFactorAssertion assertion,
    String? displayName,
  );

  @async
  void enrollTotp(
    AuthFirebaseApp app,
    String assertionId,
    String? displayName,
  );

  @async
  MultiFactorSession getSession(
    AuthFirebaseApp app,
  );

  @async
  void unenroll(
    AuthFirebaseApp app,
    String factorUid,
  );

  @async
  List<MultiFactorInfo> getEnrolledFactors(
    AuthFirebaseApp app,
  );
}

@HostApi(dartHostTestHandler: 'TestMultiFactoResolverHostApi')
abstract class MultiFactoResolverHostApi {
  @async
  UserCredential resolveSignIn(
    String resolverId,
    PhoneMultiFactorAssertion? assertion,
    String? totpAssertionId,
  );
}

class TotpSecret {
  const TotpSecret({
    required this.codeIntervalSeconds,
    required this.codeLength,
    required this.enrollmentCompletionDeadline,
    required this.hashingAlgorithm,
    required this.secretKey,
  });

  final int? codeIntervalSeconds;
  final int? codeLength;
  final int? enrollmentCompletionDeadline;
  final String? hashingAlgorithm;
  final String secretKey;
}

@HostApi(dartHostTestHandler: 'TestMultiFactoResolverHostApi')
abstract class MultiFactorTotpHostApi {
  @async
  TotpSecret generateSecret(
    String sessionId,
  );

  @async
  String getAssertionForEnrollment(
    String secretKey,
    String oneTimePassword,
  );

  @async
  String getAssertionForSignIn(
    String enrollmentId,
    String oneTimePassword,
  );
}

@HostApi(dartHostTestHandler: 'TestMultiFactoResolverHostApi')
abstract class MultiFactorTotpSecretHostApi {
  @async
  String generateQrCodeUrl(
    String secretKey,
    String? accountName,
    String? issuer,
  );

  @async
  void openInOtpApp(
    String secretKey,
    String qrCodeUrl,
  );
}

/// Only used to generate the object interface that are use outside of the  interface
@HostApi()
abstract class GenerateInterfaces {
  void pigeonInterface(MultiFactorInfo info);
}
