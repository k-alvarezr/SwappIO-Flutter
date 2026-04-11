import '../../core/services/firestore_service.dart';
import '../models/dropoff_point.dart';

abstract class DropOffRepository {
  Future<List<DropOffPoint>> getDropOffPoints();
}

class DropOffRepositoryImpl implements DropOffRepository {
  DropOffRepositoryImpl(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<List<DropOffPoint>> getDropOffPoints() => _firestoreService.getDropOffPoints();
}
