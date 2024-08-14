import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripCostEvent extends Equatable {
  const TripCostEvent();
  @override
  List<Object?> get props => [];
}

class TripCostStart extends TripCostEvent {}

class TripCostLoadAll extends TripCostEvent {
  final DatabaseTrip trip;

  const TripCostLoadAll({required this.trip});

  @override
  List<Object?> get props => [trip.id];
}

class TripCostAdd extends TripCostEvent {
  final DatabaseTrip trip;

  const TripCostAdd({required this.trip});
  @override
  List<Object?> get props => [trip.id];
}

class TripCostUpdate extends TripCostEvent {
  final String fieldName;
  final String text;
  final DatabaseCost cost;
  final DatabaseTrip trip;

  const TripCostUpdate({
    required this.trip,
    required this.fieldName,
    required this.text,
    required this.cost,
  });

  @override
  List<Object?> get props => [fieldName, text, cost.id, trip.id];
}

class TripCostRemove extends TripCostEvent {
  final DatabaseCost cost;
  final DatabaseTrip trip;

  const TripCostRemove({
    required this.trip,
    required this.cost,
  });
  @override
  List<Object?> get props => [cost.id];
}

class TripCostRemoveAll extends TripCostEvent {
  final DatabaseTrip trip;
  final bool? shouldDelete;

  const TripCostRemoveAll({
    required this.trip,
    required this.shouldDelete,
  });
  @override
  List<Object?> get props => [trip.id];
}
