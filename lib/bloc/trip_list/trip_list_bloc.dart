import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_utils.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';

class TripListBloc extends Bloc<TripListEvent, TripListState> {
  TripListBloc(TripListUtils utils) : super(const TripListInitial()) {
    on<TripListLoadAll>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListLoadInProgress());
      List<DatabaseTrip> tripsList = await utils.getAllTrips();
      //simulating complex compution
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
      emit(TripListLoadSuccess(allTrips: tripsList));

      //emit(TripListLoadFailure()); TODO
    });

    on<TripListAdd>((event, emit) async {
      Stopwatch stopwatch = Stopwatch()..start();
      emit(const TripListAddInProgress());
      DatabaseTrip newTrip = await utils.addTrip();
//simulating complex compution
      if (stopwatch.elapsed.inMilliseconds < 200) {
        await Future.delayed(
            Duration(milliseconds: 200 - stopwatch.elapsed.inMilliseconds));
      }

      emit(TripListAddSuccess(
        trip: newTrip,
        route: tripEditRoute,
      ));
      //simulating complex compution
      if (stopwatch.elapsed.inMilliseconds < 250) {
        await Future.delayed(
            Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
      }
    });

    on<TripListRemove>((event, emit) async {
      final shouldDelete = await showConfirmationDialog(
        context: event.context,
        title: event.dialogTitle,
        content: event.dialogContent,
      );

      if (shouldDelete == true) {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripListRemoveInProgress());
        await utils.deleteTrip(event.trip);
        List<DatabaseTrip> tripsList = await utils.getAllTrips();

        //  emit(const TripListInitial());
        //simulating complex compution
        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(const TripListRemoveSuccess());
        emit(TripListLoadSuccess(allTrips: tripsList));
      }
    });

    on<TripListTripClick>((event, emit) async {
      emit(TripListClicked(
        route: tripEditRoute,
        trip: event.trip,
      ));
    });
  }
}
