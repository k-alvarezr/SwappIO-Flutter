import 'MockSwapioRepositoryViewModel.dart';
import '../model/AppUserModel.dart';
import '../model/CharityModel.dart';
import '../model/ChatChannelModel.dart';
import '../model/DropoffPointModel.dart';
import '../model/ProductModel.dart';
import 'FirestoreServiceViewModel.dart';

class MockFirestoreServiceViewModel implements FirestoreServiceViewModel {
  MockFirestoreServiceViewModel(this._backend);

  final MockSwapioRepositoryViewModel _backend;

  @override
  Future<AppUserModel> getCurrentUser() async => _backend.currentUser!;

  @override
  Future<AppUserModel> getUserById(String userId) async => _backend.getUser(userId);

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
  Future<List<ProductModel>> getTrendingProducts() async => _backend.getTrendingProducts();

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async => _backend.getProductsByIds(ids);

  @override
  Future<List<ProductModel>> getProductsForUser(String userId) async => _backend.getProductsForUser(userId);

  @override
  Future<List<ProductModel>> getSuggestions(String productId) async => _backend.getSuggestions(productId);

  @override
  Future<ProductModel> getProductById(String productId) async => _backend.getProduct(productId);

  @override
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
      images: images,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    _backend.deleteProduct(productId);
  }

  @override
  Future<void> purchaseProduct(String productId) async {
    _backend.purchaseProduct(productId);
  }

  @override
  Future<void> donateProduct({
    required String productId,
    required String charityId,
  }) async {
    _backend.donateProduct(
      productId: productId,
      charityId: charityId,
    );
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
  Future<void> withdrawBalance(double amount) async {
    _backend.withdrawBalance(amount);
  }

  @override
  Future<List<CharityModel>> getCharities() async => _backend.getCharities();

  @override
  Future<CharityModel> getCharityById(String charityId) async => _backend.getCharity(charityId);

  @override
  Future<List<DropoffPointModel>> getDropOffPoints() async => _backend.getDropOffPoints();

  @override
  Future<List<ChatChannelModel>> getChatsForCurrentUser() async => _backend.getChatsForCurrentUser();

  @override
  Future<ChatChannelModel> getChatById(String chatId) async => _backend.getChat(chatId);

  @override
  Future<String> startChatForProduct(String productId) async => _backend.startChatForProduct(productId);

  @override
  Future<void> sendMessage(String chatId, String text) async {
    _backend.sendMessage(chatId, text);
  }
}



