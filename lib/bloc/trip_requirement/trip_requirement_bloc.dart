import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_service.dart';
import 'package:tripplanner/models/trips.dart';

class TripRequirementBloc
    extends Bloc<TripRequirementEvent, TripRequirementState> {
  TripRequirementBloc(TripRequirementService utils)
      : super(const TripRequirementInitial(exception: null)) {
    on<TripRequirementLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementLoadInProgress(exception: null));
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoaded(
        dataRows: dataRows,
        exception: null,
      ));
    });

    on<TripRequirementAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementAddInProgress(exception: null));

      Exception? exception;
      try {
        await utils.addRequirement(event.trip);
      } on Exception catch (e) {
        exception = e;
      }
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripRequirementAdded(exception: exception));

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoaded(
        dataRows: dataRows,
        exception: null,
      ));
    });

    on<TripRequirementUpdate>((event, emit) async {
      Exception? exception;
      try {
        await utils.updateRequirement(
          fieldName: event.fieldName,
          text: event.text,
          requirement: event.requirement,
        );
      } on Exception catch (e) {
        exception = e;
        emit(TripRequirementUpdated(exception: exception));
      }
    });

    on<TripRequirementRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementDeleteInProgress(exception: null));
      Exception? exception;
      try {
        await utils.deleteRequirement(event.requirement);
      } on Exception catch (e) {
        exception = e;
      }
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripRequirementDeleted(exception: exception));

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoaded(
        dataRows: dataRows,
        exception: null,
      ));
    });

    on<TripRequirementRemoveAll>((event, emit) async {
      if (event.shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripRequirementDeleteAllInProgress(exception: null));

        Exception? exception;
        try {
          await utils.deleteAllRequirement(event.trip);
        } on Exception catch (e) {
          exception = e;
        }
        // for prettier display
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(TripRequirementDeletedAll(exception: exception));
        emit(const TripRequirementLoaded(
          dataRows: [],
          exception: null,
        ));
      }
    });
  }
}
