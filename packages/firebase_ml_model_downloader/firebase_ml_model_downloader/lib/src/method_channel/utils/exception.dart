part of firebase_ml_model_downloader;
import 'package:_flutterfire_internals/_flutterfire_internals.dart';

Never convertPlatformException(Object exception, StackTrace stackTrace) {
  convertPlatformExceptionToFirebaseException(
    exception,
    stackTrace,
    plugin: 'firebase_ml_model_downloader',
  );
}
