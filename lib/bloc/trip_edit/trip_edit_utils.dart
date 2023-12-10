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
    required List<String> message,
  }) async {
    var sharedTrip = provider.getTrip(trip.id);
    String tripCosts = '';
    for (var cost in sharedTrip.costs) {
      tripCosts +=
          '[ ${message[0]}: ${cost.activity}, ${message[1]}: ${cost.planned}, ${message[2]}: ${cost.real} ]\n';
    }

    String tripRequirements = '';
    for (var requirement in sharedTrip.requirements) {
      tripRequirements +=
          '[ ${message[0]}: ${requirement.name}, ${message[3]}: ${requirement.isDone} ]\n';
    }

    String sharingText =
        ' ${message[4]} \n ${message[0]}: ${sharedTrip.name} \n ${message[5]}: ${sharedTrip.destination} \n ${message[6]}: ${sharedTrip.date} \n ${message[7]}: ${sharedTrip.note} \n ${message[8]}: $tripCosts ${message[9]}: $tripRequirements';
    Share.share(sharingText);
  }
}
