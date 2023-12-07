import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/services/crud/database_trip_provider.dart';

class TripCostUtils {
  late final provider = DatabaseTripsProvider();

  // singleton
  static final TripCostUtils _instance = TripCostUtils._internal();
  TripCostUtils._internal();
  factory TripCostUtils() {
    return _instance;
  }

  Future<void> addCost(DatabaseTrip trip) async {
    await provider.addCost(trip.id);
  }

  List<DatabaseCost> loadExistingCost(DatabaseTrip existingTrip) {
    var trip = provider.getTrip(existingTrip.id);
    List<DatabaseCost> newDataRows = [];

    if (trip.costs.isNotEmpty) {
      for (var previousCost in trip.costs) {
        newDataRows.add(
          previousCost,
        );
      }
    }
    return newDataRows;
  }

  Future<void> updateCost({
    required String fieldName,
    required String text,
    required DatabaseCost cost,
  }) async {
    await provider.updateCost(
      cost,
      fieldName,
      text,
    );
  }

  Future<void> deleteCost(DatabaseCost cost) async {
    await provider.deleteCost(cost);
  }

  Future<void> deleteAllCost(DatabaseTrip existingTrip) async {
    var trip = provider.getTrip(existingTrip.id);
    List<DatabaseCost> toRemove = [];
    for (var cost in trip.costs) {
      toRemove.add(cost);
    }
    for (var cost in toRemove) {
      await provider.deleteCost(cost);
    }
  }
}
