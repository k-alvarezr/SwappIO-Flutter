import '../../core/services/firestore_service.dart';
import '../models/charity.dart';

abstract class CharityRepository {
  Future<List<Charity>> getCharities();
  Future<Charity> getCharityById(String charityId);
}

class CharityRepositoryImpl implements CharityRepository {
  CharityRepositoryImpl(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<List<Charity>> getCharities() => _firestoreService.getCharities();

  @override
  Future<Charity> getCharityById(String charityId) => _firestoreService.getCharityById(charityId);
}
