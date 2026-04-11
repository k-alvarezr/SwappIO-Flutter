import '../../core/services/firestore_service.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<String>> getTags();
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
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<List<String>> getTags() => _firestoreService.getProductTags();

  @override
  Future<List<Product>> getTrendingProducts() => _firestoreService.getTrendingProducts();

  @override
  Future<List<Product>> getProductsByIds(List<String> ids) => _firestoreService.getProductsByIds(ids);

  @override
  Future<List<Product>> getProductsForUser(String userId) => _firestoreService.getProductsForUser(userId);

  @override
  Future<List<Product>> getSuggestions(String productId) => _firestoreService.getSuggestions(productId);

  @override
  Future<Product> getProductById(String productId) => _firestoreService.getProductById(productId);

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
    );
  }

  @override
  Future<void> deleteProduct(String productId) => _firestoreService.deleteProduct(productId);
}
