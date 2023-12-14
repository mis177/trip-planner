import 'package:share_plus/share_plus.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/trips_repository.dart';

class TripEditService {
  late final _repository = TripsRepository();

  // singleton
  static final TripEditService _instance = TripEditService._internal();
  TripEditService._internal();
  factory TripEditService() {
    return _instance;
  }

  Future<void> updateTrip({
    required String fieldName,
    required String text,
    required DatabaseTrip trip,
  }) async {
    await _repository.updateTrip(
      trip.id,
      fieldName,
      text,
    );
  }

  Future<void> shareTrip({
    required DatabaseTrip trip,
    required List<String> message,
  }) async {
    var sharedTrip = _repository.getTrip(trip.id);
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
