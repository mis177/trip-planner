import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_utils.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';

class TripRequirementBloc
    extends Bloc<TripRequirementEvent, TripRequirementState> {
  TripRequirementBloc(TripRequirementUtils utils)
      : super(const TripRequirementInitial()) {
    on<TripRequirementLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementLoadInProgress());
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(
        dataRows: dataRows,
      ));
    });

    on<TripRequirementAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripRequirementAddInProgress());

      await utils.addRequirement(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripRequirementAddSuccess());

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(
        dataRows: dataRows,
      ));
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
      emit(const TripRequirementDeleteInProgress());
      await utils.deleteRequirement(event.requirement);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripRequirementDeleteSuccess());

      List<DatabaseRequirement> dataRows =
          utils.loadExistingRequirement(event.trip);

      emit(TripRequirementLoadSuccess(
        dataRows: dataRows,
      ));
    });

    on<TripRequirementRemoveAll>((event, emit) async {
      final shouldDelete = await showConfirmationDialog(
        context: event.context,
        title: event.dialogTitle,
        content: event.dialogContent,
      );
      if (shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripRequirementDeleteAllInProgress());
        await utils.deleteAllRequirement(event.trip);
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(const TripRequirementDeleteAllSuccess());
        emit(const TripRequirementLoadSuccess(
          dataRows: [],
        ));
      }
    });
  }
}
