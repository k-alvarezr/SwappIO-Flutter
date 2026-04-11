import 'dart:math';

import '../models/app_user.dart';
import '../models/charity.dart';
import '../models/chat_models.dart';
import '../models/dropoff_point.dart';
import '../models/product.dart';

class MockSwapioRepository {
  MockSwapioRepository._() {
    _seed();
  }

  static final MockSwapioRepository instance = MockSwapioRepository._();

  final Map<String, AppUser> _users = {};
  final Map<String, Product> _products = {};
  final Map<String, Charity> _charities = {};
  final Map<String, ChatChannel> _chats = {};
  final List<DropOffPoint> _dropOffPoints = [];

  String? _currentUserId = 'user_me';

  bool get isAuthenticated => _currentUserId != null;
  AppUser? get currentUser => _currentUserId == null ? null : _users[_currentUserId];

  Future<bool> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email y contraseña son obligatorios.');
    }
    final user = _users.values.firstWhere(
      (item) => item.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('No existe una cuenta con ese correo.'),
    );
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres.');
    }
    _currentUserId = user.id;
    return true;
  }

  Future<bool> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if ([name, lastname, email, password].any((item) => item.trim().isEmpty)) {
      throw Exception('Completa todos los campos.');
    }
    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres.');
    }
    if (_users.values.any((item) => item.email.toLowerCase() == email.toLowerCase())) {
      throw Exception('Ese correo ya está registrado.');
    }
    final id = 'user_${_users.length + 1}';
    final user = AppUser(
      id: id,
      name: name.trim(),
      lastname: lastname.trim(),
      email: email.trim(),
      location: 'Bogotá, CO',
      balance: 0,
      memberSince: DateTime.now(),
    );
    _users[id] = user;
    _currentUserId = id;
    return true;
  }

  void logout() {
    _currentUserId = null;
  }

  List<String> get tags => const [
        'All',
        'Trending',
        'Dresses',
        'Shoes',
        'Jackets',
        'Accessories',
        'Pants',
      ];

  List<Product> getTrendingProducts() {
    return _products.values.where((item) => item.status == ProductStatus.available).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Product> getSuggestions(String productId) {
    return getTrendingProducts().where((item) => item.id != productId).take(4).toList();
  }

  Product getProduct(String id) => _products[id]!;
  AppUser getUser(String id) => _users[id]!;
  Charity getCharity(String id) => _charities[id]!;
  List<Charity> getCharities() => _charities.values.toList();
  List<DropOffPoint> getDropOffPoints() => List<DropOffPoint>.from(_dropOffPoints);

  List<Product> getProductsForUser(String userId) {
    return _products.values.where((item) => item.ownerId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Product> getProductsByIds(List<String> ids) {
    return ids.map((id) => _products[id]).whereType<Product>().toList();
  }

  void toggleFavorite(String productId) {
    final user = currentUser;
    if (user == null) return;
    final favs = List<String>.from(user.favorites);
    if (favs.contains(productId)) {
      favs.remove(productId);
    } else {
      favs.add(productId);
    }
    _users[user.id] = user.copyWith(favorites: favs);
  }

  void toggleFollow(String sellerId) {
    final user = currentUser;
    if (user == null) return;
    final following = List<String>.from(user.following);
    final seller = getUser(sellerId);
    final followers = List<String>.from(seller.followers);
    if (following.contains(sellerId)) {
      following.remove(sellerId);
      followers.remove(user.id);
    } else {
      following.add(sellerId);
      followers.add(user.id);
    }
    _users[user.id] = user.copyWith(following: following);
    _users[sellerId] = seller.copyWith(followers: followers);
  }

  Product addProduct({
    required String title,
    required String brand,
    required double price,
    required String size,
    required String condition,
    required String description,
    required String location,
    required List<String> tags,
  }) {
    final user = currentUser!;
    final id = 'product_${_products.length + 1}';
    final palette = _fallbackPalette(_products.length);
    final product = Product(
      id: id,
      name: title,
      price: price,
      size: size,
      images: palette,
      location: location,
      description: description,
      condition: condition,
      ownerId: user.id,
      brand: brand.isEmpty ? null : brand,
      styleTags: tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      latitude: 4.65,
      longitude: -74.06,
    );
    _products[id] = product;
    _users[user.id] = user.copyWith(
      listings: [id, ...user.listings],
    );
    return product;
  }

  void deleteProduct(String productId) {
    final user = currentUser;
    if (user == null) return;
    _products.remove(productId);
    _users[user.id] = user.copyWith(
      listings: user.listings.where((item) => item != productId).toList(),
      favorites: user.favorites.where((item) => item != productId).toList(),
    );
  }

  List<ChatChannel> getChatsForCurrentUser() {
    final user = currentUser;
    if (user == null) return [];
    final chats = _chats.values
        .where((item) => item.participantIds.contains(user.id))
        .toList()
      ..sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
    return chats;
  }

  ChatChannel getChat(String chatId) => _chats[chatId]!;

  String startChatForProduct(String productId) {
    final user = currentUser!;
    final product = getProduct(productId);
    final seller = getUser(product.ownerId);

    final existing = _chats.values.where((item) {
      return item.relatedProductId == productId &&
          item.participantIds.contains(user.id) &&
          item.participantIds.contains(seller.id);
    });
    if (existing.isNotEmpty) {
      return existing.first.id;
    }

    final id = 'chat_${_chats.length + 1}';
    _chats[id] = ChatChannel(
      id: id,
      participantIds: [user.id, seller.id],
      participantNames: {
        user.id: user.fullName,
        seller.id: seller.fullName,
      },
      participantProfilePics: {
        user.id: user.profilePictureUrl,
        seller.id: seller.profilePictureUrl,
      },
      lastMessage: 'Chat iniciado',
      lastMessageTimestamp: DateTime.now(),
      unreadCount: 0,
      relatedProductId: product.id,
      relatedProductName: product.name,
      relatedProductPrice: product.price,
      relatedProductImage: product.images.first,
      messages: [
        ChatMessage(
          id: 'message_${id}_1',
          senderId: seller.id,
          text: 'Hola, sigue disponible si te interesa.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
        ),
      ],
    );
    return id;
  }

  void sendMessage(String chatId, String text) {
    final user = currentUser!;
    final chat = getChat(chatId);
    final messages = List<ChatMessage>.from(chat.messages)
      ..insert(
        0,
        ChatMessage(
          id: 'message_${chatId}_${messagesSeed.nextInt(99999)}',
          senderId: user.id,
          text: text.trim(),
          timestamp: DateTime.now(),
        ),
      );
    _chats[chatId] = chat.copyWith(
      messages: messages,
      lastMessage: text.trim(),
      lastMessageTimestamp: DateTime.now(),
    );
  }

  static final Random messagesSeed = Random(9);

  void _seed() {
    final now = DateTime.now();
    final me = AppUser(
      id: 'user_me',
      name: 'Catalina',
      lastname: 'Rojas',
      email: 'cata@swapio.app',
      location: 'Bogotá, CO',
      balance: 185000,
      memberSince: DateTime(2024, 1, 4),
      number: '+57 310 000 0000',
      purchases: const ['product_4'],
      listings: const ['product_1'],
      favorites: const ['product_2', 'product_3'],
      following: const ['user_seller_1'],
    );
    final seller1 = AppUser(
      id: 'user_seller_1',
      name: 'Lucía',
      lastname: 'Mejía',
      email: 'lucia@swapio.app',
      location: 'Usaquén, Bogotá',
      balance: 320000,
      memberSince: DateTime(2023, 4, 8),
      number: '+57 311 111 1111',
      rating: 4.9,
      ratingCount: 84,
      soldCount: 47,
      followers: const ['user_me'],
      listings: const ['product_2', 'product_5'],
    );
    final seller2 = AppUser(
      id: 'user_seller_2',
      name: 'Tomás',
      lastname: 'Rivera',
      email: 'tomas@swapio.app',
      location: 'Chapinero, Bogotá',
      balance: 95000,
      memberSince: DateTime(2024, 3, 3),
      rating: 4.7,
      ratingCount: 21,
      soldCount: 12,
      listings: const ['product_3', 'product_4'],
    );
    _users.addAll({
      me.id: me,
      seller1.id: seller1,
      seller2.id: seller2,
    });

    final seededProducts = [
      Product(
        id: 'product_1',
        name: 'Vintage Denim Jacket',
        price: 120000,
        size: 'M',
        images: _fallbackPalette(0),
        location: 'Chapinero, Bogotá',
        description: 'Classic oversized denim jacket with clean stitching and a structured fit.',
        condition: 'Good',
        ownerId: me.id,
        styleTags: const ['Vintage', 'Streetwear'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        latitude: 4.6486,
        longitude: -74.0628,
      ),
      Product(
        id: 'product_2',
        name: 'Cream Wool Coat',
        price: 215000,
        size: 'L',
        images: _fallbackPalette(1),
        location: 'Usaquén, Bogotá',
        description: 'Long cream coat for cold days. Soft interior and polished silhouette.',
        condition: 'Like New',
        ownerId: seller1.id,
        styleTags: const ['Old Money', 'Jackets'],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
        latitude: 4.711,
        longitude: -74.031,
      ),
      Product(
        id: 'product_3',
        name: 'Nike Dunk Low',
        price: 300000,
        size: '42',
        images: _fallbackPalette(2),
        location: 'Zona T, Bogotá',
        description: 'White and green pair in strong condition with minimal sole wear.',
        condition: 'Good',
        ownerId: seller2.id,
        styleTags: const ['Shoes', 'Streetwear'],
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        latitude: 4.667,
        longitude: -74.054,
      ),
      Product(
        id: 'product_4',
        name: 'Black Midi Dress',
        price: 89000,
        size: 'S',
        images: _fallbackPalette(3),
        location: 'Cedritos, Bogotá',
        description: 'Elegant dress with square neckline and clean fall.',
        condition: 'New with tags',
        ownerId: seller2.id,
        styleTags: const ['Dresses', 'Minimalist'],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        latitude: 4.729,
        longitude: -74.043,
      ),
      Product(
        id: 'product_5',
        name: 'Leather Mini Bag',
        price: 65000,
        size: 'Unique',
        images: _fallbackPalette(4),
        location: 'Usaquén, Bogotá',
        description: 'Compact shoulder bag with magnetic closure and smooth finish.',
        condition: 'Like New',
        ownerId: seller1.id,
        styleTags: const ['Accessories', 'Coquette'],
        createdAt: now.subtract(const Duration(hours: 18)),
        updatedAt: now.subtract(const Duration(hours: 18)),
        latitude: 4.702,
        longitude: -74.029,
      ),
    ];
    for (final product in seededProducts) {
      _products[product.id] = product;
    }

    final charities = [
      Charity(
        id: 'charity_1',
        name: 'Fundación Abrigo de Vida',
        location: 'Suba, Bogotá',
        description: 'Recolecta ropa en excelente estado para familias desplazadas y mujeres cabeza de hogar.',
        impact: 'Cada donación se clasifica, reacondiciona y entrega en jornadas semanales con apoyo local.',
        distance: '1.2 km',
        tags: const ['Women', 'Clothes'],
        email: 'hola@abrigodevida.org',
        number: '+57 320 456 1001',
        website: 'www.abrigodevida.org',
      ),
      Charity(
        id: 'charity_2',
        name: 'Red Invierno Digno',
        location: 'Teusaquillo, Bogotá',
        description: 'Especializada en abrigos, zapatos y ropa térmica para habitantes de calle.',
        impact: 'Conecta puntos de acopio con equipos móviles de distribución en temporadas frías.',
        distance: '3.4 km',
        tags: const ['Winter Gear', 'Professional'],
        email: 'contacto@inviernodigno.org',
        number: '+57 315 998 1100',
        website: 'www.inviernodigno.org',
      ),
      Charity(
        id: 'charity_3',
        name: 'Pequeños Armarios',
        location: 'Kennedy, Bogotá',
        description: 'Canaliza prendas infantiles y uniformes para niños de comunidades vulnerables.',
        impact: 'Trabaja con colegios y comedores comunitarios para cubrir necesidades urgentes.',
        distance: '6.1 km',
        tags: const ['Children', 'Kids'],
        email: 'info@pequenosarmarios.org',
        number: '+57 302 123 8765',
        website: 'www.pequenosarmarios.org',
      ),
    ];
    for (final charity in charities) {
      _charities[charity.id] = charity;
    }

    _dropOffPoints.addAll(const [
      DropOffPoint(
        id: 'drop_1',
        name: 'Sede Principal Minuto',
        address: 'Calle 81A #73A-22',
        city: 'Bogotá',
        latitude: 4.68,
        longitude: -74.1,
        opensAt: '8:00 AM',
        closesAt: '5:00 PM',
      ),
      DropOffPoint(
        id: 'drop_2',
        name: 'Centro de Acopio Usaquén',
        address: 'Carrera 7 #119-14',
        city: 'Bogotá',
        latitude: 4.71,
        longitude: -74.03,
        opensAt: '9:00 AM',
        closesAt: '6:00 PM',
      ),
      DropOffPoint(
        id: 'drop_3',
        name: 'Punto Chapinero',
        address: 'Calle 59 #9-34',
        city: 'Bogotá',
        latitude: 4.64,
        longitude: -74.06,
        opensAt: '10:00 AM',
        closesAt: '7:00 PM',
      ),
    ]);

    final seededChatId = 'chat_1';
    _chats[seededChatId] = ChatChannel(
      id: seededChatId,
      participantIds: [me.id, seller1.id],
      participantNames: {
        me.id: me.fullName,
        seller1.id: seller1.fullName,
      },
      participantProfilePics: {
        me.id: me.profilePictureUrl,
        seller1.id: seller1.profilePictureUrl,
      },
      lastMessage: 'Te la puedo separar hasta mañana.',
      lastMessageTimestamp: now.subtract(const Duration(minutes: 24)),
      unreadCount: 2,
      relatedProductId: 'product_2',
      relatedProductName: 'Cream Wool Coat',
      relatedProductPrice: 215000,
      relatedProductImage: _products['product_2']!.images.first,
      messages: [
        ChatMessage(
          id: 'msg_1',
          senderId: seller1.id,
          text: 'Te la puedo separar hasta mañana.',
          timestamp: now.subtract(const Duration(minutes: 24)),
        ),
        ChatMessage(
          id: 'msg_2',
          senderId: me.id,
          text: 'Perfecto, ¿aceptas transferencia?',
          timestamp: now.subtract(const Duration(minutes: 28)),
        ),
      ],
    );
  }

  static List<String> _fallbackPalette(int index) {
    const palettes = [
      ['#6D8DA7', '#D4E4F0'],
      ['#DCC4B8', '#F6EDE3'],
      ['#4D7B63', '#E6F2EC'],
      ['#1B1B1B', '#BEBEBE'],
      ['#8C684D', '#E7D8CA'],
      ['#B3628A', '#F6E2EB'],
    ];
    return palettes[index % palettes.length];
  }
}
