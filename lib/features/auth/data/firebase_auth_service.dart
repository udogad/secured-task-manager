import 'package:firebase_auth/firebase_auth.dart';
import 'package:secure_task_manager/core/utils/results.dart'
    show Ok, Err, Result;
import '../../../core/errors/failure.dart';
import '../../auth/domain/user.dart';
import '../../auth/domain/auth_service.dart';

/// A concrete implementation of [AuthService] that uses Firebase Authentication.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService._();

  /// Singleton instance of the [FirebaseAuthService].
  static final instance = FirebaseAuthService._();
  @override
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;

  @override
  AppUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? AppUser(id: user.uid, email: user.email!) : null;
  }

  @override
  @override
  Future<Result<AppUser>> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return Ok(AppUser(id: user.uid, email: user.email!));
      } else {
        return Err(Failure('Sign in failed', code: 'auth/sign_in_failed'));
      }
    } on FirebaseAuthException catch (e) {
      return Err(Failure(e.message ?? 'An unknown error occurred', code: e.code));
    } catch (e) {
      return Err(Failure(e.toString(), code: 'auth/unknown_error'));
    }
  }

  @override
  Future<Result<AppUser>> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return Ok(AppUser(id: user.uid, email: user.email!));
      } else {
        return Err(Failure('Sign up failed', code: 'auth/sign_up_failed'));
      }
    } on FirebaseAuthException catch (e) {
      return Err(Failure(e.message ?? 'An unknown error occurred', code: e.code));
    } catch (e) {
      return Err(Failure(e.toString(), code: 'auth/unknown_error'));
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}