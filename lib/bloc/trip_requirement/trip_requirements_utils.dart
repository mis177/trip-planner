import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/database_trip_provider.dart';

class TripRequirementUtils {
  late final provider = DatabaseTripsProvider();

  // singleton
  static final TripRequirementUtils _instance =
      TripRequirementUtils._internal();
  TripRequirementUtils._internal();
  factory TripRequirementUtils() {
    return _instance;
  }

  List<DatabaseRequirement> loadExistingRequirement(DatabaseTrip existingTrip) {
    var trip = provider.getTrip(existingTrip.id);
    List<DatabaseRequirement> newDataRows = [];
    if (trip.requirements.isNotEmpty) {
      for (var previousRequirement in trip.requirements) {
        newDataRows.add(previousRequirement);
      }
    }
    return newDataRows;
  }

  Future<void> addRequirement(DatabaseTrip trip) async {
    await provider.addRequirement(trip.id);
  }

  Future<void> updateRequirement({
    required DatabaseRequirement requirement,
    required String fieldName,
    required text,
  }) async {
    if (fieldName == 'is_done') {
      text = text == 'false' ? 0 : 1;
    }
    await provider.updateRequirement(
      requirement,
      fieldName,
      text,
    );
  }

  Future<void> deleteRequirement(DatabaseRequirement requirement) async {
    await provider.deleteRequirement(requirement);
  }

  Future<void> deleteAllRequirement(DatabaseTrip existingTrip) async {
    var trip = provider.getTrip(existingTrip.id);
    List<DatabaseRequirement> toRemove = [];
    for (var requirement in trip.requirements) {
      toRemove.add(requirement);
    }
    for (var requirement in toRemove) {
      await provider.deleteRequirement(requirement);
    }
  }
}
