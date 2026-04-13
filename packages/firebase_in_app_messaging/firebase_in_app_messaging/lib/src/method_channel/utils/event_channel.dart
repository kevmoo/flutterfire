part of firebase_in_app_messaging;

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
