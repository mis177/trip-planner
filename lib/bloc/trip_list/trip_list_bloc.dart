import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_utils.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/models/trips.dart';

class TripListBloc extends Bloc<TripListEvent, TripListState> {
  TripListBloc(TripListUtils utils)
      : super(const TripListInitial(isLoading: false)) {
    on<TripListLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListLoadInProgress(
          isLoading: true, loadingText: 'Loading trips...'));
      List<DatabaseTrip> tripsList = await utils.getAllTrips();
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripListLoadSuccess(allTrips: tripsList));

      //emit(TripListLoadFailure()); TODO
    });

    on<TripListAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListAddInProgress(
          isLoading: true, loadingText: 'Creating trip...'));
      DatabaseTrip newTrip = await utils.addTrip();

      if (stopwatch.elapsed.inMilliseconds < 200) {
        await Future.delayed(
            Duration(milliseconds: 200 - stopwatch.elapsed.inMilliseconds));
      }

      emit(TripListAddSuccess(
          trip: newTrip,
          route: tripEditRoute,
          isLoading: true,
          loadingText: 'Creating trip...'));
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
    });

    on<TripListRemove>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListRemoveInProgress(
          isLoading: true, loadingText: 'Deleting trip...'));
      await utils.deleteTrip(event.trip);
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(const TripListRemoveSuccess());
      emit(const TripListInitial(
          isLoading: true, loadingText: 'Loading trips...'));
    });

    on<TripListTripClick>((event, emit) async {
      emit(TripListClicked(
        route: tripEditRoute,
        trip: event.trip,
      ));
    });
  }
}
