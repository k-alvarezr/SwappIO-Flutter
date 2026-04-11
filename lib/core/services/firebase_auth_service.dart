import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService;

  FirebaseAuthService(this._firestoreService);

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Error al iniciar sesión');
    }
  }

  @override
  Future<bool> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String uid = userCredential.user!.uid;

      await _firestoreService.saveUserData(
        id: uid,
        name: name,
        lastname: lastname,
        email: email.trim(),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Error al registrar usuario');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}