import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_utils.dart';
import 'package:tripplanner/models/trips.dart';

class TripRequirementBloc
    extends Bloc<TripRequirementEvent, TripRequirementState> {
  TripRequirementBloc(TripRequirementUtils utils)
      : super(const TripRequirementInitial(isLoading: false)) {
    on<TripRequirementLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementLoadInProgress(
        isLoading: true,
        loadingText: 'Loading requirements...',
      ));
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripRequirementAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementAddInProgress(
        isLoading: true,
        loadingText: 'Adding new requirement',
      ));

      await utils.addRequirement(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripRequirementAddSuccess(isLoading: false));

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripRequirementUpdate>((event, emit) async {
      //emit(TripRequirementUpdateInProgress(isLoading: true));
      await utils.updateRequirement(
        fieldName: event.fieldName,
        text: event.text,
        requirement: event.requirement,
      );
      //   emit(TripRequirementUpdateSuccess());
    });

    on<TripRequirementRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementDeleteInProgress(
        isLoading: true,
        loadingText: 'Deleting requirement',
      ));
      await utils.deleteRequirement(event.requirement);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripRequirementDeleteSuccess(isLoading: false));

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripRequirementRemoveAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementDeleteAllInProgress(
        isLoading: true,
        loadingText: 'Deleting all requirements',
      ));
      await utils.deleteAllRequirement(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripRequirementDeleteAllSuccess(isLoading: false));
      emit(const TripRequirementLoadSuccess(dataRows: [], isLoading: false));
    });
  }
}
