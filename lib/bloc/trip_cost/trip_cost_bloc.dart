import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:bloc/bloc.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_service.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';

class TripCostBloc extends Bloc<TripCostEvent, TripCostState> {
  TripCostBloc(TripCostService utils)
      : super(const TripCostInitial(exception: null)) {
    on<TripCostLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostLoadInProgress(exception: null));
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoaded(dataRows: dataRows, exception: null));
    });

    on<TripCostAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostAddInProgress(exception: null));
      Exception? exception;
      try {
        await utils.addCost(event.trip);
      } on Exception catch (e) {
        exception = e;
      }
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripCostAdded(exception: exception));

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoaded(dataRows: dataRows, exception: null));
    });

    on<TripCostUpdate>((event, emit) async {
      Exception? exception;
      try {
        await utils.updateCost(
          fieldName: event.fieldName,
          text: event.text,
          cost: event.cost,
        );
      } on Exception catch (e) {
        exception = e;
        emit(TripCostUpdated(exception: exception));
      }
    });

    on<TripCostRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostDeleteInProgress(exception: null));

      Exception? exception;
      try {
        await utils.deleteCost(event.cost);
      } on Exception catch (e) {
        exception = e;
      }
      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripCostDeleted(exception: exception));

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoaded(dataRows: dataRows, exception: null));
    });

    on<TripCostRemoveAll>((event, emit) async {
      if (event.shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripCostDeleteAllInProgress(exception: null));

        Exception? exception;
        try {
          await utils.deleteAllCost(event.trip);
        } on Exception catch (e) {
          exception = e;
        }
        // for prettier display
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(TripCostDeletedAll(exception: exception));
        List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);
        emit(TripCostLoaded(dataRows: dataRows, exception: null));
      }
    });
  }
}
