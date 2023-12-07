import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripListEvent extends Equatable {
  const TripListEvent();
  @override
  List<Object?> get props => [];
}

class TripListLoadAll extends TripListEvent {
  const TripListLoadAll();
}

class TripListAdd extends TripListEvent {
  const TripListAdd();
}

class TripListRemove extends TripListEvent {
  final DatabaseTrip trip;
  const TripListRemove({
    required this.trip,
  });
}

class TripListTripClick extends TripListEvent {
  final DatabaseTrip trip;

  const TripListTripClick({
    required this.trip,
  });
}
