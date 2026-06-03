import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streams connectivity status for offline UI.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  await for (final results in connectivity.onConnectivityChanged) {
    final online = results.any((r) => r != ConnectivityResult.none);
    yield online;
  }
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).maybeWhen(
        data: (online) => online,
        orElse: () => true,
      );
});
