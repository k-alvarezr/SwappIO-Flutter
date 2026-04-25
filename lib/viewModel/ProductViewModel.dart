import 'FirestoreServiceViewModel.dart';
import '../model/ProductModel.dart';

abstract class ProductViewModel {
  Future<List<String>> getTags();
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
}

class ProductViewModelImpl implements ProductViewModel {
  ProductViewModelImpl(this._firestoreService);

  final FirestoreServiceViewModel _firestoreService;

  @override
  Future<List<String>> getTags() => _firestoreService.getProductTags();

  @override
  Future<List<ProductModel>> getTrendingProducts() => _firestoreService.getTrendingProducts();

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) => _firestoreService.getProductsByIds(ids);

  @override
  Future<List<ProductModel>> getProductsForUser(String userId) => _firestoreService.getProductsForUser(userId);

  @override
  Future<List<ProductModel>> getSuggestions(String productId) => _firestoreService.getSuggestions(productId);

  @override
  Future<ProductModel> getProductById(String productId) => _firestoreService.getProductById(productId);

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
  }) {
    return _firestoreService.createProduct(
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
  Future<void> deleteProduct(String productId) => _firestoreService.deleteProduct(productId);

  @override
  Future<void> purchaseProduct(String productId) => _firestoreService.purchaseProduct(productId);

  @override
  Future<void> donateProduct({
    required String productId,
    required String charityId,
  }) {
    return _firestoreService.donateProduct(
      productId: productId,
      charityId: charityId,
    );
  }
}




