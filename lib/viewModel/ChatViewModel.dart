import 'FirestoreServiceViewModel.dart';
import '../model/ChatChannelModel.dart';

abstract class ChatViewModel {
  Future<List<ChatChannelModel>> getChatsForCurrentUser();
  Future<ChatChannelModel> getChatById(String chatId);
  Future<String> startChatForProduct(String productId);
  Future<void> sendMessage(String chatId, String text);
}

class ChatViewModelImpl implements ChatViewModel {
  ChatViewModelImpl(this._firestoreService);

  final FirestoreServiceViewModel _firestoreService;

  @override
  Future<List<ChatChannelModel>> getChatsForCurrentUser() => _firestoreService.getChatsForCurrentUser();

  @override
  Future<ChatChannelModel> getChatById(String chatId) => _firestoreService.getChatById(chatId);

  @override
  Future<String> startChatForProduct(String productId) => _firestoreService.startChatForProduct(productId);

  @override
  Future<void> sendMessage(String chatId, String text) => _firestoreService.sendMessage(chatId, text);
}




