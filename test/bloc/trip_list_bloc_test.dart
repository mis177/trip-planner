import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_service.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/models/trips.dart';

import 'trip_list_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TripListService>()])
void main() {
  group('trip_list_bloc', () {
    late TripListBloc tripListBloc;
    late DatabaseTrip trip;

    setUp(() {
      tripListBloc = TripListBloc(
        MockTripListService(),
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

    blocTest<TripListBloc, TripListState>(
      'loading trips',
      build: () => tripListBloc,
      act: (bloc) async {
        bloc.add(const TripListLoadAll());
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripListLoadInProgress(exception: null),
        const TripListLoaded(allTrips: [], exception: null),
      ],
    );

    blocTest<TripListBloc, TripListState>(
      'adding trip',
      build: () => tripListBloc,
      act: (bloc) async {
        bloc.add(const TripListAdd());
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripListAddInProgress(exception: null),
        TripListAdded(
          allTrips: const [],
          exception: null,
          route: '',
          trip: trip,
        ),
      ],
    );

    blocTest<TripListBloc, TripListState>(
      'removing trip true',
      build: () => tripListBloc,
      act: (bloc) async {
        bloc.add(TripListRemove(trip: trip, shouldDelete: true));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripListRemoveInProgress(exception: null),
        const TripListRemoved(exception: null),
        const TripListLoaded(allTrips: [], exception: null),
      ],
    );

    blocTest<TripListBloc, TripListState>(
      'removing trip false',
      build: () => tripListBloc,
      act: (bloc) async {
        bloc.add(TripListRemove(trip: trip, shouldDelete: false));
      },
      expect: () => [],
    );

    blocTest<TripListBloc, TripListState>(
      'trip clicked',
      build: () => tripListBloc,
      act: (bloc) async {
        bloc.add(TripListTripClick(trip: trip));
      },
      expect: () => [
        TripListClicked(
          route: '',
          trip: trip,
          exception: null,
        )
      ],
    );
  });
}
