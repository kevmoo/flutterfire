part of firebase_ml_model_downloader;

extension EventChannelExtension on dynamic {
  Stream<dynamic> receiveGuardedBroadcastStream({
    dynamic arguments,
    required dynamic Function(Object error, StackTrace stackTrace) onError,
  }) {
    final incomingStackTrace = StackTrace.current;
    return this.receiveBroadcastStream(arguments).handleError((Object error) {
      return onError(error, incomingStackTrace);
    });
  }
}
