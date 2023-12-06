import 'package:equatable/equatable.dart';

sealed class TripEditEvent extends Equatable {
  const TripEditEvent();
  @override
  List<Object?> get props => [];
}

class TripLoad extends TripEditEvent {}

class TripInfoUpdate extends TripEditEvent {}

class TripCostsPressed extends TripEditEvent {}

class TripRequirementsPressed extends TripEditEvent {}
