// ignore_for_file: require_trailing_commas
// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_auth;

/// Method Channel delegate for [FirebaseAuthPlatform].
class MethodChannelFirebaseAuth extends FirebaseAuthPlatform {
  /// The [MethodChannelFirebaseAuth] method channel.
  static const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_auth',
  );

  final FirebaseAuthHostApi _api = FirebaseAuthHostApi();

  /// Map of [MethodChannelFirebaseAuth] that can be get with Firebase App Name.
  @visibleForTesting
  static Map<String, MethodChannelFirebaseAuth> methodChannelFirebaseAuthInstances =
      <String, MethodChannelFirebaseAuth>{};

  /// Map of [MethodChannelMultiFactor] that can be get with Firebase App Name.
  static Map<String, MethodChannelMultiFactor> _multiFactorInstances =
      <String, MethodChannelMultiFactor>{};

  StreamController<UserPlatform?>? _authStateController;
  StreamController<UserPlatform?>? _idTokenStateController;
  StreamController<UserPlatform?>? _userChangesController;

  MethodChannelFirebaseAuth({required FirebaseApp app}) : super(app: app) {
    methodChannelFirebaseAuthInstances[app.name] = this;

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'Auth#authStateChanged':
          final Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);
          if (arguments['appName'] == app.name) {
            final UserDetails? userDetails = arguments['user'] == null
                ? null
                : UserDetails.fromMap(
                    Map<String, dynamic>.from(arguments['user']),
                  );

            _authStateController?.add(
              userDetails == null
                  ? null
                  : MethodChannelUser(this, multiFactor, userDetails),
            );
          }
          break;
        case 'Auth#idTokenChanged':
          final Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);
          if (arguments['appName'] == app.name) {
            final UserDetails? userDetails = arguments['user'] == null
                ? null
                : UserDetails.fromMap(
                    Map<String, dynamic>.from(arguments['user']),
                  );

            _idTokenStateController?.add(
              userDetails == null
                  ? null
                  : MethodChannelUser(this, multiFactor, userDetails),
            );
          }
          break;
        case 'Auth#userChanges':
          final Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);
          if (arguments['appName'] == app.name) {
            final UserDetails? userDetails = arguments['user'] == null
                ? null
                : UserDetails.fromMap(
                    Map<String, dynamic>.from(arguments['user']),
                  );

            _userChangesController?.add(
              userDetails == null
                  ? null
                  : MethodChannelUser(this, multiFactor, userDetails),
            );
          }
          break;
        default:
          throw UnimplementedError();
      }
    });
  }

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) {
    return MethodChannelFirebaseAuth(app: app);
  }

  @override
  MethodChannelMultiFactor get multiFactor {
    return _multiFactorInstances.putIfAbsent(
      app.name,
      () => MethodChannelMultiFactor(this),
    );
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    Map<String, dynamic>? currentUser,
    String? languageCode,
  }) {
    this.languageCode = languageCode;
    if (currentUser != null) {
      this.currentUser = MethodChannelUser(
        this,
        multiFactor,
        UserDetails.fromMap(currentUser),
      );
    }
    return this;
  }

  @override
  void registerMultiFactorInstances(
    MethodChannelMultiFactor multiFactorInstance,
  ) {
    _multiFactorInstances[app.name] = multiFactorInstance;
  }

  AuthPigeonFirebaseApp get pigeonDefault =>
      AuthPigeonFirebaseApp(appName: app.name);

  @override
  Future<void> useAuthEmulator(String host, int port) async {
    try {
      await _api.useAuthEmulator(pigeonDefault, host, port.toInt());
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> applyActionCode(String code) async {
    try {
      await _api.applyActionCode(pigeonDefault, code);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<ActionCodeInfo> checkActionCode(String code) async {
    try {
      final result = await _api.checkActionCode(pigeonDefault, code);
      return ActionCodeInfo(result.asMap());
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _api.confirmPasswordReset(pigeonDefault, code, newPassword);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _api.createUserWithEmailAndPassword(
        pigeonDefault,
        email,
        password,
      );
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      final result = await _api.fetchSignInMethodsForEmail(pigeonDefault, email);
      return result.whereType<String>().toList();
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> getRedirectResult() async {
    try {
      final result = await _api.getRedirectResult(pigeonDefault);
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  bool isSignInWithEmailLink(String emailLink) {
    // This is currently a synchronous call on the native side
    // and Pigeon doesn't support synchronous calls yet.
    // For now, we will use the MethodChannel directly.
    // TODO(ehesp): Move to Pigeon when it supports synchronous calls.
    return false;
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) async {
    try {
      await _api.sendPasswordResetEmail(
        pigeonDefault,
        email,
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
  Future<void> sendSignInLinkToEmail({
    required String email,
    required ActionCodeSettings actionCodeSettings,
  }) async {
    try {
      await _api.sendSignInLinkToEmail(
        pigeonDefault,
        email,
        PigeonActionCodeSettings(
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
  Future<void> setLanguageCode(String? languageCode) async {
    try {
      await _api.setLanguageCode(pigeonDefault, languageCode);
      this.languageCode = languageCode;
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> setSettings({
    bool? appVerificationDisabledForTesting,
    String? userAccessGroup,
    String? phoneNumber,
    String? smsCode,
    bool? forceRecaptchaFlow,
  }) async {
    try {
      await _api.setSettings(
        pigeonDefault,
        PigeonFirebaseAuthSettings(
          appVerificationDisabledForTesting: appVerificationDisabledForTesting,
          userAccessGroup: userAccessGroup,
          phoneNumber: phoneNumber,
          smsCode: smsCode,
          forceRecaptchaFlow: forceRecaptchaFlow,
        ),
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> setPersistence(Persistence persistence) async {
    try {
      await _api.setPersistence(pigeonDefault, persistence.index.toInt());
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInAnonymously() async {
    try {
      final result = await _api.signInAnonymously(pigeonDefault);
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithCredential(
    AuthCredential credential,
  ) async {
    try {
      final result = await _api.signInWithCredential(
        pigeonDefault,
        credential.asMap(),
      );
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithCustomToken(String token) async {
    try {
      final result = await _api.signInWithCustomToken(pigeonDefault, token);
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _api.signInWithEmailAndPassword(
        pigeonDefault,
        email,
        password,
      );
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      final result = await _api.signInWithEmailLink(
        pigeonDefault,
        email,
        emailLink,
      );
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithProvider(
    AuthProvider provider,
  ) async {
    try {
      final convertedProvider = convertToOAuthProvider(provider);

      final result = await _api.signInWithProvider(
        pigeonDefault,
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
      return MethodChannelUserCredential(this, result);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<UserCredentialPlatform> signInWithPopup(AuthProvider provider) async {
    throw UnimplementedError(
      'signInWithPopup() is only supported on web based platforms',
    );
  }

  @override
  Future<void> signInWithRedirect(AuthProvider provider) async {
    throw UnimplementedError(
      'signInWithRedirect() is only supported on web based platforms',
    );
  }

  @override
  Future<void> signOut() async {
    try {
      await _api.signOut(pigeonDefault);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> verifyPasswordResetCode(String code) async {
    try {
      await _api.verifyPasswordResetCode(pigeonDefault, code);
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    String? phoneNumber,
    PhoneMultiFactorInfo? multiFactorInfo,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
    MultiFactorSession? multiFactorSession,
  }) async {
    final String verificationId =
        await MethodChannelPhoneAuthCallbacks.registerCallbacks(
      verificationCompleted,
      verificationFailed,
      codeSent,
      codeAutoRetrievalTimeout,
    );

    try {
      await _api.verifyPhoneNumber(
        pigeonDefault,
        PigeonVerifyPhoneNumberRequest(
          phoneNumber: phoneNumber,
          multiFactorInfo: multiFactorInfo == null
              ? null
              : PigeonMultiFactorInfo(
                  displayName: multiFactorInfo.displayName,
                  enrollmentTimestamp:
                      multiFactorInfo.enrollmentTimestamp.toInt(),
                  factorId: multiFactorInfo.factorId,
                  uid: multiFactorInfo.uid,
                  phoneNumber: multiFactorInfo.phoneNumber,
                ),
          verificationId: verificationId,
          autoRetrievedSmsCodeForTesting: autoRetrievedSmsCodeForTesting,
          timeout: timeout.inMilliseconds.toInt(),
          forceResendingToken: forceResendingToken?.toInt(),
          multiFactorSession: multiFactorSession == null
              ? null
              : PigeonMultiFactorSession(id: multiFactorSession.id),
        ),
      );
    } catch (e, stack) {
      convertPlatformException(e, stack);
    }
  }

  @override
  Stream<UserPlatform?> authStateChanges() {
    _authStateController ??= StreamController<UserPlatform?>.broadcast();
    return _authStateController!.stream;
  }

  @override
  Stream<UserPlatform?> idTokenChanges() {
    _idTokenStateController ??= StreamController<UserPlatform?>.broadcast();
    return _idTokenStateController!.stream;
  }

  @override
  Stream<UserPlatform?> userChanges() {
    _userChangesController ??= StreamController<UserPlatform?>.broadcast();
    return _userChangesController!.stream;
  }
}
