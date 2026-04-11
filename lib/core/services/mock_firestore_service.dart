import '../../data/mock/mock_swapio_repository.dart';
import '../../data/models/app_user.dart';
import '../../data/models/charity.dart';
import '../../data/models/chat_models.dart';
import '../../data/models/dropoff_point.dart';
import '../../data/models/product.dart';
import 'firestore_service.dart';

class MockFirestoreService implements FirestoreService {
  MockFirestoreService(this._backend);

  final MockSwapioRepository _backend;

  @override
  Future<AppUser> getCurrentUser() async => _backend.currentUser!;

  @override
  Future<AppUser> getUserById(String userId) async => _backend.getUser(userId);

  @override
  Future<void> saveUserData({
    required String id,
    required String name,
    required String lastname,
    required String email,
  }) async {
    // Como esto es solo de prueba (mock), no necesitamos guardar nada real.
    // Solo imprimimos en consola para saber que funcionó.
    print('Mock simulando guardado de usuario: $name $lastname');
  }

  @override
  Future<List<String>> getProductTags() async => _backend.tags;

  @override
  Future<List<Product>> getTrendingProducts() async => _backend.getTrendingProducts();

  @override
  Future<List<Product>> getProductsByIds(List<String> ids) async => _backend.getProductsByIds(ids);

  @override
  Future<List<Product>> getProductsForUser(String userId) async => _backend.getProductsForUser(userId);

  @override
  Future<List<Product>> getSuggestions(String productId) async => _backend.getSuggestions(productId);

  @override
  Future<Product> getProductById(String productId) async => _backend.getProduct(productId);

  @override
  Future<Product> createProduct({
    required String title,
    required String brand,
    required double price,
    required String size,
    required String condition,
    required String description,
    required String location,
    required List<String> tags,
  }) async {
    return _backend.addProduct(
      title: title,
      brand: brand,
      price: price,
      size: size,
      condition: condition,
      description: description,
      location: location,
      tags: tags,
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    _backend.deleteProduct(productId);
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    _backend.toggleFavorite(productId);
  }

  @override
  Future<void> toggleFollow(String sellerId) async {
    _backend.toggleFollow(sellerId);
  }

  @override
  Future<List<Charity>> getCharities() async => _backend.getCharities();

  @override
  Future<Charity> getCharityById(String charityId) async => _backend.getCharity(charityId);

  @override
  Future<List<DropOffPoint>> getDropOffPoints() async => _backend.getDropOffPoints();

  @override
  Future<List<ChatChannel>> getChatsForCurrentUser() async => _backend.getChatsForCurrentUser();

  @override
  Future<ChatChannel> getChatById(String chatId) async => _backend.getChat(chatId);

  @override
  Future<String> startChatForProduct(String productId) async => _backend.startChatForProduct(productId);

  @override
  Future<void> sendMessage(String chatId, String text) async {
    _backend.sendMessage(chatId, text);
  }
}
