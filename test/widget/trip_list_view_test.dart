// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:path_provider/path_provider.dart';
// //import 'package:mockito/mockito.dart';
// import 'package:tripplanner/bloc/trip_list/trip_list_bloc.dart';
// import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
// import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
// import 'package:tripplanner/views/trips/trip_requirements_view.dart';

// import 'package:mocktail/mocktail.dart';

// class MockTripListBloc extends MockBloc<TripListEvent, TripListState>
//     implements TripListBloc {}

// void main() {
//   late TripListBloc tripListBloc;
//   setUp(() {
//     tripListBloc = MockTripListBloc();
//   });
//   group('trip_list_view', () {
//     testWidgets('AppBar has titile and actions button', (tester) async {
//       tripListBloc = MockTripListBloc();
//       when(() => tripListBloc.state).thenReturn(
//         TripListInitial(exception: null),
//       );

//       //  await tester.pumpWidget(const TripsListView());
//       await tester.pumpWidget(
//         BlocProvider.value(
//           value: tripListBloc,
//           child: const RequirementsListView(),
//         ),
//       );

//       final titleFinder = find.byType(Scaffold);
//       expect(titleFinder, findsOneWidget);
//     });
//   });
// }
