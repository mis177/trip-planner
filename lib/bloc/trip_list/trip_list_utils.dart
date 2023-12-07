import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/database_trip_provider.dart';

class TripListUtils {
  late final provider = DatabaseTripsProvider();

  // singleton
  static final TripListUtils _instance = TripListUtils._internal();
  TripListUtils._internal();
  factory TripListUtils() {
    return _instance;
  }

  Future<List<DatabaseTrip>> getAllTrips() async {
    final allTrips = await provider.getAllTrips();
    final tripsList = allTrips.toList();
    return tripsList;
  }

  Future<DatabaseTrip> addTrip() async {
    DatabaseTrip trip = await provider.addTrip();
    return trip;
  }

  Future<void> deleteTrip(DatabaseTrip trip) async {
    await provider.deleteTrip(trip);
  }
}
