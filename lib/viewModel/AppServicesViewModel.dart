import 'package:firebase_core/firebase_core.dart';

import 'AuthServiceViewModel.dart';
import 'AuthViewModel.dart';
import 'CharityViewModel.dart';
import 'ChatViewModel.dart';
import 'DropoffViewModel.dart';
import 'FirebaseAuthServiceViewModel.dart';
import 'FirebaseFirestoreServiceViewModel.dart';
import 'FirestoreServiceViewModel.dart';
import 'MockAuthServiceViewModel.dart';
import 'MockFirestoreServiceViewModel.dart';
import 'MockPaymentGatewayViewModel.dart';
import 'MockSwapioRepositoryViewModel.dart';
import 'PaymentGatewayViewModel.dart';
import 'ProductViewModel.dart';
import 'UserViewModel.dart';

class AppServicesViewModel {
  AppServicesViewModel._({
    required this.authService,
    required this.firestoreService,
    required this.authRepository,
    required this.userRepository,
    required this.productRepository,
    required this.paymentGatewayRepository,
    required this.charityRepository,
    required this.chatRepository,
    required this.dropOffRepository,
  });

  final AuthServiceViewModel authService;
  final FirestoreServiceViewModel firestoreService;
  final AuthViewModel authRepository;
  final UserViewModel userRepository;
  final ProductViewModel productRepository;
  final PaymentGatewayViewModel paymentGatewayRepository;
  final CharityViewModel charityRepository;
  final ChatViewModel chatRepository;
  final DropoffViewModel dropOffRepository;

  static final AppServicesViewModel instance = () {
    final bool useFirebase = Firebase.apps.isNotEmpty;
    final FirestoreServiceViewModel firestoreService = useFirebase
        ? FirebaseFirestoreServiceViewModel()
        : MockFirestoreServiceViewModel(MockSwapioRepositoryViewModel.instance);
    final AuthServiceViewModel authService = useFirebase
        ? FirebaseAuthServiceViewModel(firestoreService)
        : MockAuthServiceViewModel(MockSwapioRepositoryViewModel.instance);
    return AppServicesViewModel._(
      authService: authService,
      firestoreService: firestoreService,
      authRepository: AuthViewModelImpl(authService),
      userRepository: UserViewModelImpl(firestoreService),
      productRepository: ProductViewModelImpl(firestoreService),
      paymentGatewayRepository: MockPaymentGatewayViewModel(),
      charityRepository: CharityViewModelImpl(firestoreService),
      chatRepository: ChatViewModelImpl(firestoreService),
      dropOffRepository: DropoffViewModelImpl(firestoreService),
    );
  }();
}



