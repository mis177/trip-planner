import 'package:tripplanner/models/trips.dart';

class TripShareFormatter {
  String formatShareMessage(DatabaseTrip trip, List<String> message) {
    String tripCosts = '';
    for (var cost in trip.costs) {
      tripCosts += '[ ${message[0]}: ${cost.activity}, ${message[1]}: ${cost.planned}, ${message[2]}: ${cost.real} ]\n';
    }

    String tripRequirements = '';
    for (var requirement in trip.requirements) {
      tripRequirements += '[ ${message[0]}: ${requirement.name}, ${message[3]}: ${requirement.isDone} ]\n';
    }

    return ' ${message[4]} \n ${message[0]}: ${trip.name} \n ${message[5]}: ${trip.destination} \n ${message[6]}: ${trip.date} \n ${message[7]}: ${trip.note} \n ${message[8]}: $tripCosts ${message[9]}: $tripRequirements';
  }
}
