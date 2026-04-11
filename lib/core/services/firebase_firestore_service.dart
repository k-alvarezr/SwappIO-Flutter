import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/app_user.dart';
import '../../data/models/charity.dart';
import '../../data/models/chat_models.dart';
import '../../data/models/dropoff_point.dart';
import '../../data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class FirebaseFirestoreService implements FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> saveUserData({
    required String id,
    required String name,
    required String lastname,
    required String email,
  }) async {
    await _db.collection('users').doc(id).set({
      'name': name,
      'lastname': lastname,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Product> createProduct({
    required String title, // Nota: tu UI lo llama title, pero en BD se llama name
    required String brand,
    required double price,
    required String size,
    required String condition,
    required String description,
    required String location,
    required List<String> tags,
  }) async {
    // 1. Verificamos quién está subiendo la ropa
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) throw Exception('Debes iniciar sesión para publicar');

    try {
      // 2. Le pedimos a Firestore que nos prepare un "espacio" nuevo con un ID único
      final docRef = _db.collection('products').doc();

      // 3. Empaquetamos los datos como un JSON para la base de datos
      await docRef.set({
        'name': title, // Mapeamos 'title' de tu UI a 'name' de la BD
        'brand': brand,
        'price': price,
        'size': size,
        'condition': condition,
        'description': description,
        'location': location,
        'styleTags': tags,
        'ownerId': userAuth.uid,
        'status': 'available', // Siempre empieza disponible
        'images': [], // Por ahora vacío hasta que conectemos Storage
        'discount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 4. Devolvemos el objeto Product creado para que la UI lo pueda mostrar
      return Product(
        id: docRef.id,
        name: title,
        price: price,
        size: size,
        brand: brand,
        images: [],
        location: location,
        description: description,
        condition: condition,
        styleTags: tags,
        status: ProductStatus.available,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ownerId: userAuth.uid,
      );
    } catch (e) {
      print("Error al crear producto: $e");
      throw Exception('Hubo un problema al publicar tu prenda. Intenta de nuevo.');
    }
  }

  @override
  Future<void> deleteProduct(String productId) {
    throw UnimplementedError('Pendiente integración con Firestore.');
  }

  @override
  Future<ChatChannel> getChatById(String chatId) async {
    final doc = await _db.collection('chats').doc(chatId).get();
    final data = doc.data()!;

    // Traemos la subcolección de mensajes
    final messagesSnapshot = await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    final messages = messagesSnapshot.docs.map((mDoc) {
      final mData = mDoc.data();
      return ChatMessage(
        id: mDoc.id,
        senderId: mData['senderId'] ?? '',
        text: mData['text'] ?? '',
        timestamp: (mData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isRead: mData['isRead'] ?? false,
      );
    }).toList();

    return ChatChannel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      participantNames: Map<String, String>.from(data['participantNames'] ?? {}),
      participantProfilePics: Map<String, String?>.from(data['participantProfilePics'] ?? {}),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTimestamp: (data['lastMessageTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: data['unreadCount'] ?? 0,
      messages: messages, // Aquí inyectamos los mensajes que acabamos de leer
    );
  }

  @override
  Future<List<Charity>> getCharities() async {
    try {
      final snapshot = await _db.collection('charities').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Función defensiva para extraer listas sin importar cómo se guardaron
        List<String> parseList(dynamic value) {
          if (value is List) return value.map((e) => e.toString()).toList();
          return [];
        }

        return Charity(
          id: doc.id,
          // Forzamos todo a String de forma segura usando ?.toString()
          name: data['name']?.toString() ?? 'Fundación sin nombre',
          location: data['location']?.toString() ?? 'Sin ubicación',
          description: data['description']?.toString() ?? '',
          impact: data['impact']?.toString() ?? '',
          distance: data['distance']?.toString() ?? '',
          tags: parseList(data['tags']),
          email: data['email']?.toString() ?? '',
          number: data['number']?.toString() ?? '',
          website: data['website']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      print("Error trayendo fundaciones: $e");
      return [];
    }
  }

  @override
  Future<Charity> getCharityById(String charityId) {
    throw UnimplementedError('Pendiente integración con Firestore.');
  }

  @override
  Future<AppUser> getCurrentUser() async {
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) throw Exception('No hay usuario logueado en Auth');

    final doc = await _db.collection('users').doc(userAuth.uid).get();

    Map<String, dynamic> data;

    if (!doc.exists) {
      print('⚠️ Documento no encontrado. Creando perfil de emergencia...');
      // Creamos el documento que faltó
      await _db.collection('users').doc(userAuth.uid).set({
        'name': 'Usuario',
        'lastname': 'Nuevo',
        'email': userAuth.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      data = {
        'name': 'Usuario',
        'lastname': 'Nuevo',
        'email': userAuth.email ?? '',
      };
    } else {
      data = doc.data()!;
    }

    DateTime memberSinceDate = DateTime.now();
    if (data['createdAt'] != null) {
      if (data['createdAt'] is Timestamp) {
        memberSinceDate = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is int) {
        memberSinceDate = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
      }
    }

    return AppUser(
      id: userAuth.uid,
      name: data['name'] ?? 'Usuario',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      location: data['location'] ?? 'Sin especificar',
      balance: (data['balance'] ?? 0).toDouble(),
      memberSince: memberSinceDate,
      profilePictureUrl: data['profilePictureUrl'],
      number: data['number'] ?? '',
      rating: (data['rating'] ?? 4.8).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      soldCount: data['soldCount'] ?? 0,
      purchases: List<String>.from(data['purchases'] ?? []),
      listings: List<String>.from(data['listings'] ?? []),
      favorites: List<String>.from(data['favorites'] ?? []),
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
    );
  }

  @override
  Future<List<DropOffPoint>> getDropOffPoints() async {
    try {
      final snapshot = await _db.collection('dropoff_points').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Función súper defensiva para evitar crashes matemáticos en Web
        double parseDouble(dynamic value) {
          if (value == null) return 0.0;
          if (value is num) return value.toDouble();
          if (value is String) return double.tryParse(value) ?? 0.0;
          return 0.0;
        }

        return DropOffPoint(
          id: doc.id,
          name: data['name']?.toString() ?? 'Punto de entrega',
          address: data['address']?.toString() ?? 'Dirección no disponible',
          city: data['city']?.toString() ?? 'Ciudad',
          // Pasamos los datos por nuestro filtro matemático
          latitude: parseDouble(data['latitude']),
          longitude: parseDouble(data['longitude']),
          opensAt: data['opensAt']?.toString() ?? '00:00',
          closesAt: data['closesAt']?.toString() ?? '00:00',
        );
      }).toList();
    } catch (e) {
      print("Error trayendo puntos de entrega: $e");
      return [];
    }
  }

  @override
  Future<Product> getProductById(String productId) async {
    try {
      final doc = await _db.collection('products').doc(productId).get();
      if (!doc.exists) throw Exception('El producto que buscas ya no existe.');

      final data = doc.data()!;

      DateTime parseDate(dynamic dateValue) {
        if (dateValue == null) return DateTime.now();
        if (dateValue is Timestamp) return dateValue.toDate();
        if (dateValue is int) return DateTime.fromMillisecondsSinceEpoch(dateValue);
        return DateTime.now();
      }

      // --- NUEVO FILTRO DE IMÁGENES ---
      List<String> rawImages = List<String>.from(data['images'] ?? []);
      List<String> safeImages = rawImages.map((img) {
        if (img.startsWith('http')) return 'CFD8DC';
        return img;
      }).toList();

      if (safeImages.isEmpty) safeImages = ['CFD8DC'];
      // --------------------------------

      return Product(
        id: doc.id,
        name: data['name'] ?? 'Sin nombre',
        price: (data['price'] ?? 0).toDouble(),
        size: data['size'] ?? 'N/A',
        images: safeImages, // Usamos la lista filtrada aquí
        location: data['location'] ?? 'Sin ubicación',
        description: data['description'] ?? '',
        condition: data['condition'] ?? 'Desconocida',
        ownerId: data['ownerId'] ?? '',
        discount: (data['discount'] ?? 0).toDouble(),
        brand: data['brand'],
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
        styleTags: List<String>.from(data['styleTags'] ?? []),
        status: ProductStatus.available,
        createdAt: parseDate(data['createdAt']),
        updatedAt: parseDate(data['updatedAt']),
      );
    } catch (e) {
      print("Error obteniendo producto: $e");
      rethrow;
    }
  }

  @override
  Future<List<String>> getProductTags() async {
    return ['All', 'Trending', 'Dresses', 'Shoes', 'Jackets'];
  }

  @override
  Future<List<Product>> getProductsByIds(List<String> ids) {
    throw UnimplementedError('Pendiente integración con Firestore.');
  }

  @override
  Future<List<Product>> getSuggestions(String productId) async {
    // Por ahora devolvemos una lista vacía para desbloquear la pantalla de detalles.
    return [];
  }

  @override
  Future<List<Product>> getTrendingProducts() async {
    try {
      final snapshot = await _db.collection('products').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime parseDate(dynamic dateValue) {
          if (dateValue == null) return DateTime.now();
          if (dateValue is Timestamp) return dateValue.toDate();
          if (dateValue is int) return DateTime.fromMillisecondsSinceEpoch(dateValue);
          return DateTime.now();
        }

        // --- NUEVO FILTRO DE IMÁGENES ---
        List<String> rawImages = List<String>.from(data['images'] ?? []);
        List<String> safeImages = rawImages.map((img) {
          // Si es un link real, pasamos un color hexadecimal por defecto (Ej: un gris azulado claro)
          if (img.startsWith('http')) return 'CFD8DC';
          return img;
        }).toList();

        if (safeImages.isEmpty) safeImages = ['CFD8DC']; // Color por si la lista viene vacía
        // --------------------------------

        return Product(
          id: doc.id,
          name: data['name'] ?? 'Sin nombre',
          price: (data['price'] ?? 0).toDouble(),
          size: data['size'] ?? 'N/A',
          images: safeImages, // Usamos la lista filtrada aquí
          location: data['location'] ?? 'Sin ubicación',
          description: data['description'] ?? '',
          condition: data['condition'] ?? 'Desconocida',
          ownerId: data['ownerId'] ?? '',
          discount: (data['discount'] ?? 0).toDouble(),
          brand: data['brand'],
          latitude: (data['latitude'] as num?)?.toDouble(),
          longitude: (data['longitude'] as num?)?.toDouble(),
          styleTags: List<String>.from(data['styleTags'] ?? []),
          status: ProductStatus.available,
          createdAt: parseDate(data['createdAt']),
          updatedAt: parseDate(data['updatedAt']),
        );
      }).toList();
    } catch (e) {
      print("Error trayendo productos: $e");
      return [];
    }
  }

  @override
  Future<List<Product>> getProductsForUser(String userId) async {
    try {
      // Le decimos a Firestore: Trae todos los productos DONDE el dueño sea este usuario
      final snapshot = await _db
          .collection('products')
          .where('ownerId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Reutilizamos el parseo seguro de fechas
        DateTime parseDate(dynamic dateValue) {
          if (dateValue == null) return DateTime.now();
          if (dateValue is Timestamp) return dateValue.toDate();
          if (dateValue is int) return DateTime.fromMillisecondsSinceEpoch(dateValue);
          return DateTime.now();
        }

        // Reutilizamos el filtro de imágenes para que no explote
        List<String> rawImages = List<String>.from(data['images'] ?? []);
        List<String> safeImages = rawImages.map((img) {
          if (img.startsWith('http')) return 'CFD8DC';
          return img;
        }).toList();

        if (safeImages.isEmpty) safeImages = ['CFD8DC'];

        return Product(
          id: doc.id,
          name: data['name'] ?? 'Sin nombre',
          price: (data['price'] ?? 0).toDouble(),
          size: data['size'] ?? 'N/A',
          images: safeImages,
          location: data['location'] ?? 'Sin ubicación',
          description: data['description'] ?? '',
          condition: data['condition'] ?? 'Desconocida',
          ownerId: data['ownerId'] ?? '',
          discount: (data['discount'] ?? 0).toDouble(),
          brand: data['brand'],
          latitude: (data['latitude'] as num?)?.toDouble(),
          longitude: (data['longitude'] as num?)?.toDouble(),
          styleTags: List<String>.from(data['styleTags'] ?? []),
          status: ProductStatus.available,
          createdAt: parseDate(data['createdAt']),
          updatedAt: parseDate(data['updatedAt']),
        );
      }).toList();
    } catch (e) {
      print("Error trayendo productos del usuario $userId: $e");
      return []; // Devolvemos lista vacía para no romper la app
    }
  }

  @override
  Future<AppUser> getUserById(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();

      // SALVAVIDAS: Si el usuario dueño de la prenda no existe, mandamos uno falso
      // para que la pantalla no explote y puedas ver la ropa.
      if (!doc.exists) {
        return AppUser(
          id: userId,
          name: 'Vendedor',
          lastname: 'Desconocido',
          email: 'no-reply@swapio.app',
          location: 'Desconocida',
          balance: 0.0,
          memberSince: DateTime.now(),
        );
      }

      final data = doc.data()!;

      DateTime parseDate(dynamic dateValue) {
        if (dateValue == null) return DateTime.now();
        if (dateValue is Timestamp) return dateValue.toDate();
        if (dateValue is int) return DateTime.fromMillisecondsSinceEpoch(dateValue);
        return DateTime.now();
      }

      return AppUser(
        id: doc.id,
        name: data['name'] ?? 'Usuario',
        lastname: data['lastname'] ?? '',
        email: data['email'] ?? '',
        location: data['location'] ?? 'Sin especificar',
        balance: (data['balance'] ?? 0).toDouble(),
        memberSince: parseDate(data['createdAt']),
        profilePictureUrl: data['profilePictureUrl'],
        number: data['number'] ?? '',
        rating: (data['rating'] ?? 4.8).toDouble(),
        ratingCount: data['ratingCount'] ?? 0,
        soldCount: data['soldCount'] ?? 0,
        purchases: List<String>.from(data['purchases'] ?? []),
        listings: List<String>.from(data['listings'] ?? []),
        favorites: List<String>.from(data['favorites'] ?? []),
        followers: List<String>.from(data['followers'] ?? []),
        following: List<String>.from(data['following'] ?? []),
      );
    } catch (e) {
      print("Error trayendo usuario $userId: $e");
      throw Exception('Error al cargar el perfil del vendedor');
    }
  }

  @override
  Future<List<ChatChannel>> getChatsForCurrentUser() async {
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) return [];

    try {
      // Buscamos en la colección 'chats' donde tu ID esté en la lista de participantes
      final snapshot = await _db
          .collection('chats')
          .where('participantIds', arrayContains: userAuth.uid)
          .orderBy('lastMessageTimestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatChannel(
          id: doc.id,
          participantIds: List<String>.from(data['participantIds'] ?? []),
          participantNames: Map<String, String>.from(data['participantNames'] ?? {}),
          participantProfilePics: Map<String, String?>.from(data['participantProfilePics'] ?? {}),
          lastMessage: data['lastMessage'] ?? '',
          lastMessageTimestamp: (data['lastMessageTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          unreadCount: data['unreadCount'] ?? 0,
          relatedProductId: data['relatedProductId'],
          relatedProductName: data['relatedProductName'],
          relatedProductPrice: (data['relatedProductPrice'] ?? 0).toDouble(),
          relatedProductImage: data['relatedProductImage'],
        );
      }).toList();
    } catch (e) {
      print("Error cargando chats: $e");
      return [];
    }
  }

  @override
  Future<void> sendMessage(String chatId, String text) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) return;

    final timestamp = FieldValue.serverTimestamp();

    // 1. Guardamos el mensaje en la subcolección
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': userAuth.uid,
      'text': text,
      'timestamp': timestamp,
      'isRead': false,
    });

    // 2. Actualizamos el documento principal del chat para que se vea el último mensaje
    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTimestamp': timestamp,
    });
  }

  @override
  Future<String> startChatForProduct(String productId) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) throw Exception('Inicia sesión para chatear');

    // Traemos la info del producto para saber quién es el dueño
    final productDoc = await _db.collection('products').doc(productId).get();
    final productData = productDoc.data()!;
    final sellerId = productData['ownerId'];

    // Creamos el nuevo canal de chat
    final newChatDoc = await _db.collection('chats').add({
      'participantIds': [userAuth.uid, sellerId],
      'lastMessage': '¡Hola! Estoy interesado en tu producto.',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'relatedProductId': productId,
      'relatedProductName': productData['name'],
      'unreadCount': 0,
    });

    return newChatDoc.id;
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    if (userAuth == null) throw Exception('Debes iniciar sesión para guardar favoritos');

    final userRef = _db.collection('users').doc(userAuth.uid);

    try {
      final doc = await userRef.get();
      if (!doc.exists) throw Exception('Perfil de usuario no encontrado');

      List<dynamic> currentFavorites = doc.data()?['favorites'] ?? [];

      if (currentFavorites.contains(productId)) {
        await userRef.update({
          'favorites': FieldValue.arrayRemove([productId])
        });
        print('💔 Producto $productId removido de favoritos');
      } else {
        await userRef.update({
          'favorites': FieldValue.arrayUnion([productId])
        });
        print('❤️ Producto $productId añadido a favoritos');
      }
    } catch (e) {
      print("Error al actualizar favoritos: $e");
      throw Exception('No pudimos actualizar tus favoritos.');
    }
  }

  @override
  Future<void> toggleFollow(String sellerId) {
    throw UnimplementedError('Pendiente integración con Firestore.');
  }
}
