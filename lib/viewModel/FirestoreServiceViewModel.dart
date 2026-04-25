import '../model/AppUserModel.dart';
import '../model/CharityModel.dart';
import '../model/ChatChannelModel.dart';
import '../model/DropoffPointModel.dart';
import '../model/ProductModel.dart';

abstract class FirestoreServiceViewModel {
  Future<AppUserModel> getCurrentUser();
  Future<AppUserModel> getUserById(String userId);
  Future<List<String>> getProductTags();
  Future<List<ProductModel>> getTrendingProducts();
  Future<List<ProductModel>> getProductsByIds(List<String> ids);
  Future<List<ProductModel>> getProductsForUser(String userId);
  Future<List<ProductModel>> getSuggestions(String productId);
  Future<ProductModel> getProductById(String productId);
  Future<ProductModel> createProduct({
    required String title,
    required String brand,
    required double price,
    required String size,
    required String condition,
    required String description,
    required String location,
    required List<String> tags,
    required List<String> images,
    double? latitude,
    double? longitude,
  });
  Future<void> deleteProduct(String productId);
  Future<void> purchaseProduct(String productId);
  Future<void> donateProduct({
    required String productId,
    required String charityId,
  });
  Future<void> toggleFavorite(String productId);
  Future<void> toggleFollow(String sellerId);
  Future<void> withdrawBalance(double amount);
  Future<List<CharityModel>> getCharities();
  Future<CharityModel> getCharityById(String charityId);
  Future<List<DropoffPointModel>> getDropOffPoints();
  Future<List<ChatChannelModel>> getChatsForCurrentUser();
  Future<ChatChannelModel> getChatById(String chatId);
  Future<String> startChatForProduct(String productId);
  Future<void> sendMessage(String chatId, String text);
  Future<void> saveUserData({
    required String id,
    required String name,
    required String lastname,
    required String email,
  });
}


