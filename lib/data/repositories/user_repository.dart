import '../../core/services/firestore_service.dart';
import '../models/app_user.dart';

abstract class UserRepository {
  Future<AppUser> getCurrentUser();
  Future<AppUser> getUserById(String userId);
  Future<void> toggleFavorite(String productId);
  Future<void> toggleFollow(String sellerId);
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<AppUser> getCurrentUser() => _firestoreService.getCurrentUser();

  @override
  Future<AppUser> getUserById(String userId) => _firestoreService.getUserById(userId);

  @override
  Future<void> toggleFavorite(String productId) => _firestoreService.toggleFavorite(productId);

  @override
  Future<void> toggleFollow(String sellerId) => _firestoreService.toggleFollow(sellerId);
}
