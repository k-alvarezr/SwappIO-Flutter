import 'FirestoreServiceViewModel.dart';
import '../model/AppUserModel.dart';

abstract class UserViewModel {
  Future<AppUserModel> getCurrentUser();
  Future<AppUserModel> getUserById(String userId);
  Future<void> toggleFavorite(String productId);
  Future<void> toggleFollow(String sellerId);
  Future<void> withdrawBalance(double amount);
}

class UserViewModelImpl implements UserViewModel {
  UserViewModelImpl(this._firestoreService);

  final FirestoreServiceViewModel _firestoreService;

  @override
  Future<AppUserModel> getCurrentUser() => _firestoreService.getCurrentUser();

  @override
  Future<AppUserModel> getUserById(String userId) => _firestoreService.getUserById(userId);

  @override
  Future<void> toggleFavorite(String productId) => _firestoreService.toggleFavorite(productId);

  @override
  Future<void> toggleFollow(String sellerId) => _firestoreService.toggleFollow(sellerId);

  @override
  Future<void> withdrawBalance(double amount) => _firestoreService.withdrawBalance(amount);
}




