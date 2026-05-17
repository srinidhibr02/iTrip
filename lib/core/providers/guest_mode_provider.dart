import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _guestKey = 'guest_mode';

/// Allows demo/guest access without Firebase authentication.
final guestModeProvider = StateNotifierProvider<GuestModeNotifier, bool>((ref) {
  return GuestModeNotifier();
});

class GuestModeNotifier extends StateNotifier<bool> {
  GuestModeNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_guestKey) ?? false;
  }

  Future<void> enableGuestMode() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
  }

  Future<void> disableGuestMode() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, false);
  }
}
