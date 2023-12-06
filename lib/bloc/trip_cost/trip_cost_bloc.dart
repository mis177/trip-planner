import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:bloc/bloc.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_utils.dart';

class TripCostBloc extends Bloc<TripCostEvent, TripCostState> {
  TripCostBloc(TripCostUtils utils)
      : super(const TripCostInitial(isLoading: false)) {
    on<TripCostLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostLoadInProgress(
        isLoading: true,
        loadingText: 'Loading costs...',
      ));
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripCostAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostAddInProgress(
        isLoading: true,
        loadingText: 'Adding new cost',
      ));

      await utils.addCost(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripCostAddSuccess(isLoading: false));

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripCostUpdate>((event, emit) async {
      //emit(TripCostUpdateInProgress(isLoading: true));
      await utils.updateCost(
        fieldName: event.fieldName,
        text: event.text,
        cost: event.cost,
      );
      //   emit(TripCostUpdateSuccess());
    });

    on<TripCostRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostDeleteInProgress(
        isLoading: true,
        loadingText: 'Deleting cost',
      ));
      await utils.deleteCost(event.cost);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripCostDeleteSuccess(isLoading: false));

      List<DatabaseCost> dataRows = utils.loadExistingCost(event.trip);

      emit(TripCostLoadSuccess(dataRows: dataRows, isLoading: false));
    });

    on<TripCostRemoveAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripCostDeleteAllInProgress(
        isLoading: true,
        loadingText: 'Deleting all costs',
      ));
      await utils.deleteAllCost(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripCostDeleteAllSuccess(isLoading: false));
      emit(const TripCostLoadSuccess(dataRows: [], isLoading: false));
    });
  }
}
