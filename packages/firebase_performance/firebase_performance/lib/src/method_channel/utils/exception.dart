part of firebase_performance;
import 'package:_flutterfire_internals/_flutterfire_internals.dart';

Never convertPlatformException(Object exception, StackTrace stackTrace) {
  convertPlatformExceptionToFirebaseException(
    exception,
    stackTrace,
    plugin: 'firebase_performance',
  );
}
