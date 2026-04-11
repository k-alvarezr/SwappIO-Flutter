import '../../data/models/app_user.dart';
import '../../data/models/charity.dart';
import '../../data/models/chat_models.dart';
import '../../data/models/dropoff_point.dart';
import '../../data/models/product.dart';

abstract class FirestoreService {
  Future<AppUser> getCurrentUser();
  Future<AppUser> getUserById(String userId);
  Future<List<String>> getProductTags();
  Future<List<Product>> getTrendingProducts();
  Future<List<Product>> getProductsByIds(List<String> ids);
  Future<List<Product>> getProductsForUser(String userId);
  Future<List<Product>> getSuggestions(String productId);
  Future<Product> getProductById(String productId);
  Future<Product> createProduct({
    required String title,
    required String brand,
    required double price,
    required String size,
    required String condition,
    required String description,
    required String location,
    required List<String> tags,
  });
  Future<void> deleteProduct(String productId);
  Future<void> toggleFavorite(String productId);
  Future<void> toggleFollow(String sellerId);
  Future<List<Charity>> getCharities();
  Future<Charity> getCharityById(String charityId);
  Future<List<DropOffPoint>> getDropOffPoints();
  Future<List<ChatChannel>> getChatsForCurrentUser();
  Future<ChatChannel> getChatById(String chatId);
  Future<String> startChatForProduct(String productId);
  Future<void> sendMessage(String chatId, String text);
  Future<void> saveUserData({
    required String id,
    required String name,
    required String lastname,
    required String email,
  });
}
