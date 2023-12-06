import 'package:equatable/equatable.dart';

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
  const TripEditLoadSuccess({super.isLoading, super.loadingText});
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

class TripEditCostsSelectInProgress extends TripEditState {
  const TripEditCostsSelectInProgress({super.isLoading, super.loadingText});
}

class TripEditCostsSelectSuccess extends TripEditState {
  const TripEditCostsSelectSuccess({super.isLoading, super.loadingText});
}

class TripEditCostsSelectFailure extends TripEditState {
  const TripEditCostsSelectFailure({super.isLoading, super.loadingText});
}

class TripEditRequirementsSelectInProgress extends TripEditState {
  const TripEditRequirementsSelectInProgress(
      {super.isLoading, super.loadingText});
}

class TripEditRequirementsSelectSuccess extends TripEditState {
  const TripEditRequirementsSelectSuccess({super.isLoading, super.loadingText});
}

class TripEditRequirementsSelectFailure extends TripEditState {
  const TripEditRequirementsSelectFailure({super.isLoading, super.loadingText});
}
