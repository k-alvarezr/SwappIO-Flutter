enum ProductStatus { available, donated, sold }

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.images,
    required this.location,
    required this.description,
    required this.condition,
    required this.ownerId,
    this.discount = 0,
    this.brand,
    this.latitude,
    this.longitude,
    this.styleTags = const [],
    this.status = ProductStatus.available,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final double price;
  final double discount;
  final String size;
  final String? brand;
  final List<String> images;
  final String location;
  final double? latitude;
  final double? longitude;
  final String description;
  final String condition;
  final List<String> styleTags;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerId;

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? discount,
    String? size,
    String? brand,
    List<String>? images,
    String? location,
    double? latitude,
    double? longitude,
    String? description,
    String? condition,
    List<String>? styleTags,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      size: size ?? this.size,
      brand: brand ?? this.brand,
      images: images ?? this.images,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      styleTags: styleTags ?? this.styleTags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}




