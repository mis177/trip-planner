import 'package:bloc/bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_event.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_state.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_service.dart';

class TripEditBloc extends Bloc<TripEditEvent, TripEditState> {
  TripEditBloc(TripEditService utils) : super(const TripEditInitial(exception: null)) {
    on<TripLoad>(
      (event, emit) async {
        emit(const TripEditLoadInProgress(exception: null));

        emit(TripEditLoaded(trip: event.trip, exception: null));
      },
    );

    on<TripEditUpdate>(
      (event, emit) async {
        Exception? exception;
        try {
          utils.updateTrip(
            fieldName: event.fieldName,
            text: event.text,
            trip: event.trip,
          );
        } on Exception catch (e) {
          exception = e;
          emit(TripEditUpdated(exception: exception));
        }
      },
    );

    on<TripEditTablePress>((event, emit) {
      emit(TripEditTableSelected(
        route: event.route,
        trip: event.trip,
        exception: null,
      ));
      emit(TripEditLoaded(trip: event.trip, exception: null));
    });

    on<TripEditSharePress>((event, emit) async {
      await utils.shareTrip(trip: event.trip, message: event.message);
    });
  }
}
