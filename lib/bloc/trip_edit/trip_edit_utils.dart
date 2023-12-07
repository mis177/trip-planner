import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/database_trip_provider.dart';

class TripEditUtils {
  late final provider = DatabaseTripsProvider();

  // singleton
  static final TripEditUtils _instance = TripEditUtils._internal();
  TripEditUtils._internal();
  factory TripEditUtils() {
    return _instance;
  }

  Future<void> updateTrip({
    required String fieldName,
    required String text,
    required DatabaseTrip trip,
  }) async {
    await provider.updateTrip(
      trip.id,
      fieldName,
      text,
    );
  }
}
