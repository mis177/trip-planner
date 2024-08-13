import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/trips_repository.dart';

class TripCostService {
  late final TripsRepository _repository = TripsRepository();

  // singleton
  static final TripCostService _instance = TripCostService._internal();
  TripCostService._internal();
  factory TripCostService() {
    return _instance;
  }

  Future<void> addCost(DatabaseTrip trip) async {
    Stopwatch stopwatch = Stopwatch()..start();
    await _repository.addCost(trip.id);
    if (stopwatch.elapsed.inMilliseconds < 250) {
      await Future.delayed(Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
    }
  }

  List<DatabaseCost> loadExistingCost(DatabaseTrip existingTrip) {
    return _repository.getTrip(existingTrip.id).costs;
  }

  Future<void> updateCost({
    required String fieldName,
    required String text,
    required DatabaseCost cost,
  }) async {
    await _repository.updateCost(
      cost,
      fieldName,
      text,
    );
  }

  Future<void> deleteCost(DatabaseCost cost) async {
    await _repository.deleteCost(cost);
  }

  Future<void> deleteAllCost(DatabaseTrip existingTrip) async {
    var trip = _repository.getTrip(existingTrip.id);
    List<DatabaseCost> toRemove = [];
    for (var cost in trip.costs) {
      toRemove.add(cost);
    }
    for (var cost in toRemove) {
      await _repository.deleteCost(cost);
    }
  }
}
