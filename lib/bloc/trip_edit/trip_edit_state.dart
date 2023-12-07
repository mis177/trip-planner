import 'package:equatable/equatable.dart';
import 'package:tripplanner/models/trips.dart';

sealed class TripEditState extends Equatable {
  final bool isLoading;
  final String loadingText;
  final DatabaseTrip? trip;
  const TripEditState({
    this.loadingText = 'Please wait a moment',
    this.isLoading = false,
    this.trip,
  });
  @override
  List<Object?> get props => [trip?.id];
}

class TripEditInitial extends TripEditState {
  const TripEditInitial({
    super.loadingText,
    super.isLoading,
    super.trip,
  });
}

class TripEditLoadInProgress extends TripEditState {
  const TripEditLoadInProgress({
    super.loadingText,
    super.isLoading,
    super.trip,
  });
}

class TripEditLoadSuccess extends TripEditState {
  const TripEditLoadSuccess({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}

class TripEditLoadFailure extends TripEditState {
  const TripEditLoadFailure({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}

class TripEditUpdateInProgress extends TripEditState {
  const TripEditUpdateInProgress({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}

class TripEditUpdateSuccess extends TripEditState {
  const TripEditUpdateSuccess({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}

class TripEditUpdateFailure extends TripEditState {
  const TripEditUpdateFailure({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}

class TripEditTableSelect extends TripEditState {
  final String route;
  const TripEditTableSelect({
    super.isLoading,
    super.loadingText,
    required this.route,
    super.trip,
  });
}

class TripEditTableSelectFailure extends TripEditState {
  const TripEditTableSelectFailure({
    super.isLoading,
    super.loadingText,
    super.trip,
  });
}
