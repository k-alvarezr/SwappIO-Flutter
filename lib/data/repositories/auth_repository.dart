import '../../core/services/auth_service.dart';

abstract class AuthRepository {
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

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  String? get currentUserId => _authService.currentUserId;

  @override
  Future<bool> login(String email, String password) {
    return _authService.login(email, password);
  }

  @override
  Future<bool> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
  }) {
    return _authService.register(
      name: name,
      lastname: lastname,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return _authService.logout();
  }
}
