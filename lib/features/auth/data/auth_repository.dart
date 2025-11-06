import 'package:secure_task_manager/core/utils/results.dart';
import 'package:secure_task_manager/features/auth/domain/user.dart';
import 'package:secure_task_manager/features/auth/domain/auth_service.dart';
import 'package:secure_task_manager/features/auth/data/firebase_auth_service.dart';

/// A repository that provides authentication services, choosing between Hive and Firebase.
class AuthRepository implements AuthService {
  final AuthService _authService;

  AuthRepository._(this._authService);

  /// Singleton instance of the AuthRepository.
  static final instance = AuthRepository._(_determineAuthService());

  static AuthService _determineAuthService() {
    return FirebaseAuthService.instance;
  }

  @override
  bool get isSignedIn => _authService.isSignedIn;

  @override
  AppUser? get currentUser => _authService.currentUser;

  @override
  Future<Result<AppUser>> signInWithEmail(String email, String password) {
    return _authService.signInWithEmail(email, password);
  }

  @override
  Future<Result<AppUser>> signUpWithEmail(String email, String password) {
    return _authService.signUpWithEmail(email, password);
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }
}