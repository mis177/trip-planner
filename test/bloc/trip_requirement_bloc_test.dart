import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_service.dart';
import 'package:tripplanner/models/trips.dart';

import 'trip_requirement_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TripRequirementService>()])
void main() {
  group('trip_requirement_bloc', () {
    late TripRequirementBloc tripRequirementBloc;
    late DatabaseTrip trip;
    late DatabaseRequirement requirement;

    setUp(() {
      tripRequirementBloc = TripRequirementBloc(
        MockTripRequirementService(),
      );

      trip = DatabaseTrip(
          id: 1,
          name: '',
          destination: '',
          date: '',
          note: '',
          costs: [],
          requirements: []);

      requirement = DatabaseRequirement(
        id: 1,
        name: '',
        isDone: true,
        tripID: 1,
      );
    });

    blocTest<TripRequirementBloc, TripRequirementState>(
      'loading requirements',
      build: () => tripRequirementBloc,
      act: (bloc) async {
        bloc.add(TripRequirementLoadAll(trip: trip));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripRequirementLoadInProgress(exception: null),
        const TripRequirementLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripRequirementBloc, TripRequirementState>(
      'adding requirement',
      build: () => tripRequirementBloc,
      act: (bloc) async {
        bloc.add(TripRequirementAdd(trip: trip));
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripRequirementAddInProgress(exception: null),
        const TripRequirementAdded(exception: null),
        const TripRequirementLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripRequirementBloc, TripRequirementState>(
      'updating requirement',
      build: () => tripRequirementBloc,
      act: (bloc) async => bloc.add(
        TripRequirementUpdate(
          trip: trip,
          fieldName: '',
          text: '',
          requirement: requirement,
        ),
      ),
      wait: const Duration(milliseconds: 250),
      expect: () => [],
    );

    blocTest<TripRequirementBloc, TripRequirementState>(
      'deleting requirement',
      build: () => tripRequirementBloc,
      act: (bloc) async {
        bloc.add(
          TripRequirementRemove(
            trip: trip,
            requirement: requirement,
          ),
        );
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripRequirementDeleteInProgress(exception: null),
        const TripRequirementDeleted(exception: null),
        const TripRequirementLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripRequirementBloc, TripRequirementState>(
      'deleting all requirements true',
      build: () => tripRequirementBloc,
      act: (bloc) async {
        bloc.add(
          TripRequirementRemoveAll(
            trip: trip,
            shouldDelete: true,
          ),
        );
      },
      wait: const Duration(milliseconds: 250),
      expect: () => [
        const TripRequirementDeleteAllInProgress(exception: null),
        const TripRequirementDeletedAll(exception: null),
        const TripRequirementLoaded(dataRows: [], exception: null),
      ],
    );

    blocTest<TripRequirementBloc, TripRequirementState>(
      'deleting all requirements false',
      build: () => tripRequirementBloc,
      act: (bloc) async {
        bloc.add(
          TripRequirementRemoveAll(
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
