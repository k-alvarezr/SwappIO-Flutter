import '../../core/services/firestore_service.dart';
import '../models/chat_models.dart';

abstract class ChatRepository {
  Future<List<ChatChannel>> getChatsForCurrentUser();
  Future<ChatChannel> getChatById(String chatId);
  Future<String> startChatForProduct(String productId);
  Future<void> sendMessage(String chatId, String text);
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<List<ChatChannel>> getChatsForCurrentUser() => _firestoreService.getChatsForCurrentUser();

  @override
  Future<ChatChannel> getChatById(String chatId) => _firestoreService.getChatById(chatId);

  @override
  Future<String> startChatForProduct(String productId) => _firestoreService.startChatForProduct(productId);

  @override
  Future<void> sendMessage(String chatId, String text) => _firestoreService.sendMessage(chatId, text);
}
