part of firebase_analytics;

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
