import 'AuthServiceViewModel.dart';

abstract class AuthViewModel {
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

class AuthViewModelImpl implements AuthViewModel {
  AuthViewModelImpl(this._authService);

  final AuthServiceViewModel _authService;

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




