import 'FirestoreServiceViewModel.dart';
import '../model/CharityModel.dart';

abstract class CharityViewModel {
  Future<List<CharityModel>> getCharities();
  Future<CharityModel> getCharityById(String charityId);
}

class CharityViewModelImpl implements CharityViewModel {
  CharityViewModelImpl(this._firestoreService);

  final FirestoreServiceViewModel _firestoreService;

  @override
  Future<List<CharityModel>> getCharities() => _firestoreService.getCharities();

  @override
  Future<CharityModel> getCharityById(String charityId) => _firestoreService.getCharityById(charityId);
}




