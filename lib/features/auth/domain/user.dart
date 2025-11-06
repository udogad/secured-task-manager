/// Represents a user of the application.
class AppUser {
  /// The unique identifier of the user.
  final String id;

  /// The email address of the user.
  final String email;

  /// Creates a new [AppUser].
  const AppUser({required this.id, required this.email});
}
