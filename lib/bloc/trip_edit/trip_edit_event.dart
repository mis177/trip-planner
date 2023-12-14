import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripEditEvent extends Equatable {
  const TripEditEvent();
  @override
  List<Object?> get props => [];
}

class TripLoad extends TripEditEvent {
  final DatabaseTrip trip;

  const TripLoad({required this.trip});

  @override
  List<Object?> get props => [trip.id];
}

class TripEditUpdate extends TripEditEvent {
  final String fieldName;
  final String text;
  final DatabaseTrip trip;

  const TripEditUpdate({
    required this.fieldName,
    required this.text,
    required this.trip,
  });

  @override
  List<Object?> get props => [fieldName, text, trip.id];
}

class TripEditTablePress extends TripEditEvent {
  final String route;
  final DatabaseTrip trip;

  const TripEditTablePress({required this.route, required this.trip});
}

class TripEditSharePress extends TripEditEvent {
  final List<String> message;
  final DatabaseTrip trip;

  const TripEditSharePress({required this.trip, required this.message});
}
