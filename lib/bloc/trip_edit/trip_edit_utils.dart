import 'package:share_plus/share_plus.dart';
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

  Future<void> shareTrip({
    required DatabaseTrip trip,
  }) async {
    var sharedTrip = provider.getTrip(trip.id);
    String tripCosts = '';
    for (var cost in sharedTrip.costs) {
      tripCosts +=
          '[ Name: ${cost.activity}, Planned cost: ${cost.planned}, Real cost: ${cost.real} ]\n';
    }

    String tripRequirements = '';
    for (var requirement in sharedTrip.requirements) {
      tripRequirements +=
          '[ Name: ${requirement.name}, Done: ${requirement.isDone} ]\n';
    }

    String sharingText =
        ' Sharing trip from TripPlanner App \n Name: ${sharedTrip.name} \n Destination: ${sharedTrip.destination} \n Date: ${sharedTrip.date} \n Note: ${sharedTrip.note} \n Costs: $tripCosts Requirements: $tripRequirements';
    Share.share(sharingText);
  }
}
