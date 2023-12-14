import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/trips_repository.dart';

class TripRequirementService {
  late final _repository = TripsRepository();

  // singleton
  static final TripRequirementService _instance =
      TripRequirementService._internal();
  TripRequirementService._internal();
  factory TripRequirementService() {
    return _instance;
  }

  List<DatabaseRequirement> loadExistingRequirement(DatabaseTrip existingTrip) {
    var trip = _repository.getTrip(existingTrip.id);
    List<DatabaseRequirement> newDataRows = [];
    if (trip.requirements.isNotEmpty) {
      for (var previousRequirement in trip.requirements) {
        newDataRows.add(previousRequirement);
      }
    }
    return newDataRows;
  }

  Future<void> addRequirement(DatabaseTrip trip) async {
    await _repository.addRequirement(trip.id);
  }

  Future<void> updateRequirement({
    required DatabaseRequirement requirement,
    required String fieldName,
    required text,
  }) async {
    if (fieldName == 'is_done') {
      text = text == 'false' ? 0 : 1;
    }
    await _repository.updateRequirement(
      requirement,
      fieldName,
      text,
    );
  }

  Future<void> deleteRequirement(DatabaseRequirement requirement) async {
    await _repository.deleteRequirement(requirement);
  }

  Future<void> deleteAllRequirement(DatabaseTrip existingTrip) async {
    var trip = _repository.getTrip(existingTrip.id);
    List<DatabaseRequirement> toRemove = [];
    for (var requirement in trip.requirements) {
      toRemove.add(requirement);
    }
    for (var requirement in toRemove) {
      await _repository.deleteRequirement(requirement);
    }
  }
}
