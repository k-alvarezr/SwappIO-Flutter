import '../../data/mock/mock_swapio_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/charity_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/dropoff_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/user_repository.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'firebase_auth_service.dart';
import 'firebase_firestore_service.dart';
import 'mock_auth_service.dart';
import 'mock_firestore_service.dart';

class AppServices {
  AppServices._({
    required this.authService,
    required this.firestoreService,
    required this.authRepository,
    required this.userRepository,
    required this.productRepository,
    required this.charityRepository,
    required this.chatRepository,
    required this.dropOffRepository,
  });

  final AuthService authService;
  final FirestoreService firestoreService;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final ProductRepository productRepository;
  final CharityRepository charityRepository;
  final ChatRepository chatRepository;
  final DropOffRepository dropOffRepository;

  static final AppServices instance = () {
    final backend = MockSwapioRepository.instance;
    final firestoreService = FirebaseFirestoreService();
    final authService = FirebaseAuthService(firestoreService);
    return AppServices._(
      authService: authService,
      firestoreService: firestoreService,
      authRepository: AuthRepositoryImpl(authService),
      userRepository: UserRepositoryImpl(firestoreService),
      productRepository: ProductRepositoryImpl(firestoreService),
      charityRepository: CharityRepositoryImpl(firestoreService),
      chatRepository: ChatRepositoryImpl(firestoreService),
      dropOffRepository: DropOffRepositoryImpl(firestoreService),
    );
  }();
}
