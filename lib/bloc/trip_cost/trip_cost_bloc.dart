import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:bloc/bloc.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_utils.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';

class TripCostBloc extends Bloc<TripCostEvent, TripCostState> {
  TripCostBloc(TripCostUtils utils) : super(const TripCostInitial()) {
    on<TripCostLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostLoadInProgress());
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows));
    });

    on<TripCostAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostAddInProgress());

      await utils.addCost(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripCostAddSuccess());

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows));
    });

    on<TripCostUpdate>((event, emit) async {
      //emit(TripCostUpdateInProgress());
      await utils.updateCost(
        fieldName: event.fieldName,
        text: event.text,
        cost: event.cost,
      );
      //   emit(TripCostUpdateSuccess());
    });

    on<TripCostRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostDeleteInProgress());
      await utils.deleteCost(event.cost);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripCostDeleteSuccess());

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows));
    });

    on<TripCostRemoveAll>((event, emit) async {
      final shouldDelete = await showConfirmationDialog(
        context: event.context,
        title: event.dialogTitle,
        content: event.dialogContent,
      );
      if (shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripCostDeleteAllInProgress());
        await utils.deleteAllCost(event.trip);
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(const TripCostDeleteAllSuccess());
        List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);
        emit(TripCostLoadSuccess(dataRows: dataRows));
      }
    });
  }
}
