import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_event.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_service.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_state.dart';
import 'package:tripplanner/models/trips.dart';

import 'trip_edit_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TripEditService>()])
void main() {
  group('trip_edit_bloc', () {
    late TripEditBloc tripEditBloc;
    late DatabaseTrip trip;

    setUp(() {
      tripEditBloc = TripEditBloc(
        MockTripEditService(),
      );

      trip = DatabaseTrip(
          id: 1,
          name: '',
          destination: '',
          date: '',
          note: '',
          costs: [],
          requirements: []);
    });

    blocTest<TripEditBloc, TripEditState>(
      'loading trip',
      build: () => tripEditBloc,
      act: (bloc) async {
        bloc.add(TripLoad(trip: trip));
      },
      expect: () => [
        const TripEditLoadInProgress(exception: null),
        TripEditLoaded(trip: trip, exception: null),
      ],
    );

    blocTest<TripEditBloc, TripEditState>(
      'updating trip',
      build: () => tripEditBloc,
      act: (bloc) async {
        bloc.add(TripEditUpdate(fieldName: '', text: '', trip: trip));
      },
      expect: () => [],
    );

    blocTest<TripEditBloc, TripEditState>(
      'table pressed',
      build: () => tripEditBloc,
      act: (bloc) async {
        bloc.add(TripEditTablePress(route: 'test', trip: trip));
      },
      expect: () => [
        TripEditTableSelected(route: 'test', exception: null, trip: trip),
        TripEditLoaded(trip: trip, exception: null),
      ],
    );

    blocTest<TripEditBloc, TripEditState>(
      'sharing trip',
      build: () => tripEditBloc,
      act: (bloc) async {
        bloc.add(TripEditSharePress(trip: trip, message: const []));
      },
      expect: () => [],
    );
  });
}
