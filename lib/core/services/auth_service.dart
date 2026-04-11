abstract class AuthService {
  bool get isAuthenticated;
  String? get currentUserId;

  Future<bool> login(String email, String password);
  Future<bool> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
  });
  Future<void> logout();
}
