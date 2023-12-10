import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_event.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_state.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_utils.dart';

class TripEditBloc extends Bloc<TripEditEvent, TripEditState> {
  TripEditBloc(TripEditUtils utils) : super(const TripEditInitial()) {
    on<TripLoad>(
      (event, emit) async {
        Stopwatch stopwatch = Stopwatch()..start();
        emit(const TripEditLoadInProgress());

        if (stopwatch.elapsed.inMilliseconds < 250) {
          await Future.delayed(
              Duration(milliseconds: 250 - stopwatch.elapsed.inMilliseconds));
        }
        emit(TripEditLoadSuccess(trip: event.trip));
        //   emit(TripEditLoadFailure()); TODO
      },
    );

    on<TripEditUpdate>(
      (event, emit) async {
        // emit(
        //   const TripEditUpdateInProgress(
        //       isLoading: true, loadingText: 'Updating trip...'),
        // );

        utils.updateTrip(
          fieldName: event.fieldName,
          text: event.text,
          trip: event.trip,
        );

        //emit(const TripEditUpdateSuccess()); TODO

        // emit(const TripEditUpdateFailure());  TODO
      },
    );

    on<TripEditTablePressed>((event, emit) {
      emit(TripEditTableSelect(
        route: event.route,
        trip: event.trip,
      ));
      emit(TripEditLoadSuccess(trip: event.trip));
    });

    // on<TripEditTableSelectFailure> TODO

    on<TripEditSharePressed>((event, emit) async {
      await utils.shareTrip(trip: event.trip, message: event.message);
    });
  }
}
