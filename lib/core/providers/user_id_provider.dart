import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/providers/guest_mode_provider.dart';
import 'package:itrip/data/repositories/auth_repository.dart';

const kGuestUserId = 'guest_demo';

/// Current user ID for data operations (Firebase UID or guest).
final currentUserIdProvider = Provider<String>((ref) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  if (authUser != null) return authUser.uid;
  if (ref.watch(guestModeProvider)) return kGuestUserId;
  return kGuestUserId;
});
