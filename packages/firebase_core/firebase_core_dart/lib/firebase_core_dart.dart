// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// A generic class which provides exceptions in a Firebase-friendly format
/// to users.
@immutable
class FirebaseException implements Exception {
  /// A generic class which provides exceptions in a Firebase-friendly format
  /// to users.
  const FirebaseException({
    required this.plugin,
    this.message,
    String? code,
    this.stackTrace,
  }) : code = code ?? 'unknown';

  /// The plugin the exception is for.
  final String plugin;

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FirebaseException) return false;
    return other.plugin == plugin &&
        other.code == code &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(plugin, code, message);

  @override
  String toString() {
    String output = '[$plugin/$code] $message';

    if (stackTrace != null) {
      output += '\n\n$stackTrace';
    }

    return output;
  }
}

/// The options used to configure a Firebase app.
@immutable
class FirebaseOptions {
  /// The options used to configure a Firebase app.
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
    this.measurementId,
    this.trackingId,
    this.deepLinkURLScheme,
    this.androidClientId,
    this.iosClientId,
    this.iosBundleId,
    this.appGroupId,
  });

  /// Returns a copy of this FirebaseOptions with the given fields replaced with
  /// the new values.
  FirebaseOptions copyWith({
    String? apiKey,
    String? appId,
    String? messagingSenderId,
    String? projectId,
    String? authDomain,
    String? databaseURL,
    String? storageBucket,
    String? measurementId,
    String? trackingId,
    String? deepLinkURLScheme,
    String? androidClientId,
    String? iosClientId,
    String? iosBundleId,
    String? appGroupId,
  }) {
    return FirebaseOptions(
      apiKey: apiKey ?? this.apiKey,
      appId: appId ?? this.appId,
      messagingSenderId: messagingSenderId ?? this.messagingSenderId,
      projectId: projectId ?? this.projectId,
      authDomain: authDomain ?? this.authDomain,
      databaseURL: databaseURL ?? this.databaseURL,
      storageBucket: storageBucket ?? this.storageBucket,
      measurementId: measurementId ?? this.measurementId,
      trackingId: trackingId ?? this.trackingId,
      deepLinkURLScheme: deepLinkURLScheme ?? this.deepLinkURLScheme,
      androidClientId: androidClientId ?? this.androidClientId,
      iosClientId: iosClientId ?? this.iosClientId,
      iosBundleId: iosBundleId ?? this.iosBundleId,
      appGroupId: appGroupId ?? this.appGroupId,
    );
  }

  /// An API key used for authenticating requests from your app to Google
  /// servers.
  final String apiKey;

  /// The Google App ID that is used to uniquely identify an instance of an app.
  final String appId;

  /// The unique sender ID value used in messaging to identify your app.
  final String messagingSenderId;

  /// The Project ID from the Firebase console, for example "my-awesome-app".
  final String projectId;

  /// The auth domain used to handle redirects from OAuth provides on web
  /// platforms, for example "my-awesome-app.firebaseapp.com".
  final String? authDomain;

  /// The database root URL, for example "https://my-awesome-app.firebaseio.com."
  final String? databaseURL;

  /// The Google Cloud Storage bucket name, for example
  /// "my-awesome-app.appspot.com".
  final String? storageBucket;

  /// The project measurement ID value used on web platforms with analytics.
  final String? measurementId;

  /// The tracking ID for Google Analytics, for example "UA-12345678-1", used to
  /// configure Google Analytics.
  final String? trackingId;

  /// The URL scheme used by iOS secondary apps for Dynamic Links.
  final String? deepLinkURLScheme;

  /// The Android OAuth client ID from the Firebase Console, for example
  /// "12345.apps.googleusercontent.com."
  final String? androidClientId;

  /// The iOS client ID from the Firebase Console, for example
  /// "12345.apps.googleusercontent.com."
  final String? iosClientId;

  /// The iOS bundle ID for the application.
  final String? iosBundleId;

  /// The iOS App Group identifier to share data between the application and the
  /// application extensions.
  final String? appGroupId;

  /// The current instance as a [Map].
  Map<String, String?> get asMap {
    return <String, String?>{
      'apiKey': apiKey,
      'appId': appId,
      'messagingSenderId': messagingSenderId,
      'projectId': projectId,
      'authDomain': authDomain,
      'databaseURL': databaseURL,
      'storageBucket': storageBucket,
      'measurementId': measurementId,
      'trackingId': trackingId,
      'deepLinkURLScheme': deepLinkURLScheme,
      'androidClientId': androidClientId,
      'iosClientId': iosClientId,
      'iosBundleId': iosBundleId,
      'appGroupId': appGroupId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FirebaseOptions) return false;
    return const MapEquality().equals(asMap, other.asMap);
  }

  @override
  int get hashCode => const MapEquality().hash(asMap);

  @override
  String toString() => asMap.toString();
}
