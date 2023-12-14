import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_bloc.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_service.dart';
import 'package:tripplanner/models/trips.dart';

import 'trip_cost_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TripCostService>()])
void main() {
  group('trip_cost_bloc', () {
    late TripCostBloc tripCostBloc;
    late DatabaseTrip trip;
    late DatabaseCost cost;

    setUp(() {
      tripCostBloc = TripCostBloc(
        MockTripCostService(),
      );

      trip = DatabaseTrip(
          id: 1,
          name: '',
          destination: '',
          date: '',
          note: '',
          costs: [],
          requirements: []);

      cost = DatabaseCost(
        id: 1,
        activity: '',
        planned: 0,
        real: 0,
        tripID: 0,
      );
    });

    blocTest<TripCostBloc, TripCostState>(
      'loading costs',
      build: () => tripCostBloc,
      act: (bloc) async {
        bloc.add(TripCostLoadAll(trip: trip));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripCostLoadInProgress(exception: null),
        const TripCostLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripCostBloc, TripCostState>(
      'adding cost',
      build: () => tripCostBloc,
      act: (bloc) async {
        bloc.add(TripCostAdd(trip: trip));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripCostAddInProgress(exception: null),
        const TripCostAdded(exception: null),
        const TripCostLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripCostBloc, TripCostState>(
      'updating cost',
      build: () => tripCostBloc,
      act: (bloc) async => bloc.add(
        TripCostUpdate(
          trip: trip,
          fieldName: '',
          text: '',
          cost: cost,
        ),
      ),
      wait: const Duration(milliseconds: 250),
      expect: () => [],
    );

    blocTest<TripCostBloc, TripCostState>(
      'deleting cost',
      build: () => tripCostBloc,
      act: (bloc) async {
        bloc.add(
          TripCostRemove(
            trip: trip,
            cost: cost,
          ),
        );
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripCostDeleteInProgress(exception: null),
        const TripCostDeleted(exception: null),
        const TripCostLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripCostBloc, TripCostState>(
      'deleting all costs true',
      build: () => tripCostBloc,
      act: (bloc) async {
        bloc.add(
          TripCostRemoveAll(
            trip: trip,
            shouldDelete: true,
          ),
        );
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripCostDeleteAllInProgress(exception: null),
        const TripCostDeletedAll(exception: null),
        const TripCostLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripCostBloc, TripCostState>(
      'deleting all costs false',
      build: () => tripCostBloc,
      act: (bloc) async {
        bloc.add(
          TripCostRemoveAll(
            trip: trip,
            shouldDelete: false,
          ),
        );
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [],
    );
  });
}
