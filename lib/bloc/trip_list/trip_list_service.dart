import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/trips_repository.dart';

class TripListService {
  late final _repository = TripsRepository();

  // singleton
  static final TripListService _instance = TripListService._internal();
  TripListService._internal();
  factory TripListService() {
    return _instance;
  }

  Future<List<DatabaseTrip>> getAllTrips() async {
    final allTrips = await _repository.getAllTrips();
    final tripsList = allTrips.toList();
    return tripsList;
  }

  Future<DatabaseTrip> addTrip() async {
    DatabaseTrip trip = await _repository.addTrip();
    return trip;
  }

  Future<void> deleteTrip(DatabaseTrip trip) async {
    await _repository.deleteTrip(trip);
  }
}
