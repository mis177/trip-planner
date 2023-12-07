import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripEditState extends Equatable {
  final bool isLoading;
  final String loadingText;
  const TripEditState(
      {this.loadingText = 'Please wait a moment', this.isLoading = false});
  @override
  List<Object?> get props => [];
}

class TripEditInitial extends TripEditState {
  const TripEditInitial({super.loadingText, super.isLoading});
}

class TripEditLoadInProgress extends TripEditState {
  const TripEditLoadInProgress({super.loadingText, super.isLoading});
}

class TripEditLoadSuccess extends TripEditState {
  final DatabaseTrip trip;
  const TripEditLoadSuccess({
    super.isLoading,
    super.loadingText,
    required this.trip,
  });
  @override
  List<Object?> get props => [trip.id];
}

class TripEditLoadFailure extends TripEditState {
  const TripEditLoadFailure({super.isLoading, super.loadingText});
}

class TripEditUpdateInProgress extends TripEditState {
  const TripEditUpdateInProgress({super.isLoading, super.loadingText});
}

class TripEditUpdateSuccess extends TripEditState {
  const TripEditUpdateSuccess({super.isLoading, super.loadingText});
}

class TripEditUpdateFailure extends TripEditState {
  const TripEditUpdateFailure({super.isLoading, super.loadingText});
}

class TripEditTableSelect extends TripEditState {
  final String route;
  final DatabaseTrip trip;
  const TripEditTableSelect({
    super.isLoading,
    super.loadingText,
    required this.route,
    required this.trip,
  });
}

class TripEditTableSelectFailure extends TripEditState {
  const TripEditTableSelectFailure({super.isLoading, super.loadingText});
}
