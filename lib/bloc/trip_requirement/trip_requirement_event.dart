import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripRequirementEvent extends Equatable {
  const TripRequirementEvent();
  @override
  List<Object?> get props => [];
}

class TripRequirementStarted extends TripRequirementEvent {}

class TripRequirementLoadAll extends TripRequirementEvent {
  final DatabaseTrip trip;

  const TripRequirementLoadAll({required this.trip});
}

class TripRequirementAdd extends TripRequirementEvent {
  final DatabaseTrip trip;

  const TripRequirementAdd({required this.trip});
}

class TripRequirementUpdate extends TripRequirementEvent {
  final String fieldName;
  final String text;
  final DatabaseRequirement requirement;
  final DatabaseTrip trip;

  const TripRequirementUpdate({
    required this.trip,
    required this.fieldName,
    required this.text,
    required this.requirement,
  });

  @override
  List<Object?> get props => [fieldName, text, requirement];
}

class TripRequirementRemove extends TripRequirementEvent {
  final DatabaseRequirement requirement;
  final DatabaseTrip trip;

  const TripRequirementRemove({
    required this.trip,
    required this.requirement,
  });
  @override
  List<Object?> get props => [requirement.id];
}

class TripRequirementRemoveAll extends TripRequirementEvent {
  final DatabaseTrip trip;

  const TripRequirementRemoveAll({required this.trip});
  @override
  List<Object?> get props => [trip.id];
}
