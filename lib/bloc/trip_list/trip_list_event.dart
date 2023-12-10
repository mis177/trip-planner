import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  final List<DatabaseTrip> allTrips;
  final DatabaseTrip trip;
  final BuildContext context;
  final String dialogTitle;
  final String dialogContent;
  const TripListRemove({
    required this.allTrips,
    required this.dialogTitle,
    required this.dialogContent,
    required this.trip,
    required this.context,
  });
}

class TripListTripClick extends TripListEvent {
  final DatabaseTrip trip;

  const TripListTripClick({
    required this.trip,
  });
}
