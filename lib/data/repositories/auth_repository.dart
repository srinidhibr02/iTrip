import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/errors/failures.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/domain/entities/user_entity.dart';

/// Authentication repository — Firebase Auth with demo fallback.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Future<Result<UserEntity>> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return Success(_mapUser(credential.user!));
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Sign in failed'));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  Future<Result<UserEntity>> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return Success(_mapUser(credential.user!));
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Sign up failed'));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  Future<Result<void>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Reset failed'));
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  UserEntity _mapUser(User user) => UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime,
      );
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
