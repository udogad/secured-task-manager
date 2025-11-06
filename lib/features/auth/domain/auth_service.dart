import 'package:secure_task_manager/core/utils/results.dart';
import 'package:secure_task_manager/features/auth/domain/user.dart';

/// Abstract class defining the contract for authentication services.
abstract class AuthService {
  /// Returns true if a user is currently signed in, false otherwise.
  bool get isSignedIn;
  /// Returns the currently signed-in user, or null if no user is signed in.
  AppUser? get currentUser;
  /// Signs in a user with the given email and password.
  Future<Result<AppUser>> signInWithEmail(String email, String password);
  /// Signs in a user with the given email and password.
  Future<Result<AppUser>> signUpWithEmail(String email, String password);
  /// Signs out the current user.
  Future<void> signOut();
}