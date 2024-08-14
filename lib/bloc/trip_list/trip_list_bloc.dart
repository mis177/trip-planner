import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_service.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/models/trips.dart';

class TripListBloc extends Bloc<TripListEvent, TripListState> {
  TripListBloc(TripListService utils) : super(const TripListInitial(exception: null)) {
    on<TripListLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListLoadInProgress(exception: null));
      List<DatabaseTrip> tripsList = [];
      Exception? exception;
      try {
        tripsList = await utils.getAllTrips();
      } on Exception catch (e) {
        exception = e;
      }

      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripListLoaded(allTrips: tripsList, exception: exception));
    });

    on<TripListAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListAddInProgress(exception: null));
      DatabaseTrip newTrip = DatabaseTrip.empty();
      Exception? exception;
      try {
        newTrip = await utils.addTrip();
      } on Exception catch (e) {
        exception = e;
      }

      // for prettier display
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }

      emit(TripListAdded(
        trip: newTrip,
        route: tripEditRoute,
        exception: exception,
      ));
    });

    on<TripListRemove>((event, emit) async {
      if (event.shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripListRemoveInProgress(exception: null));
        Exception? exception;
        try {
          await utils.deleteTrip(event.trip);
        } on Exception catch (e) {
          exception = e;
        }
        List<DatabaseTrip> tripsList = [];
        Exception? exceptionAllTrips;
        try {
          tripsList = await utils.getAllTrips();
        } on Exception catch (e) {
          exception = e;
        }

        // for prettier display
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(TripListRemoved(exception: exception));
        emit(TripListLoaded(allTrips: tripsList, exception: exceptionAllTrips));
      }
    });

    on<TripListTripClick>((event, emit) async {
      emit(TripListClicked(
        route: tripEditRoute,
        trip: event.trip,
        exception: null,
      ));
    });
  }
}
