import 'MockSwapioRepositoryViewModel.dart';
import 'AuthServiceViewModel.dart';

class MockAuthServiceViewModel implements AuthServiceViewModel {
  MockAuthServiceViewModel(this._backend);

  final MockSwapioRepositoryViewModel _backend;

  @override
  bool get isAuthenticated => _backend.isAuthenticated;

  @override
  String? get currentUserId => _backend.currentUser?.id;

  @override
  Future<bool> login(String email, String password) {
    return _backend.login(email, password);
  }

  @override
  Future<bool> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
  }) {
    return _backend.register(
      name: name,
      lastname: lastname,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    _backend.logout();
  }
}



