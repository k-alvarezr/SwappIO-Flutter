import 'FirestoreServiceViewModel.dart';
import '../model/DropoffPointModel.dart';

abstract class DropoffViewModel {
  Future<List<DropoffPointModel>> getDropOffPoints();
}

class DropoffViewModelImpl implements DropoffViewModel {
  DropoffViewModelImpl(this._firestoreService);

  final FirestoreServiceViewModel _firestoreService;

  @override
  Future<List<DropoffPointModel>> getDropOffPoints() => _firestoreService.getDropOffPoints();
}




