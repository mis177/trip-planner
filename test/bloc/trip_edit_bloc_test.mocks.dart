// Mocks generated by Mockito 5.4.3 from annotations
// in tripplanner/test/bloc/trip_edit_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:tripplanner/bloc/trip_edit/trip_edit_service.dart' as _i2;
import 'package:tripplanner/models/trips.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [TripEditService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTripEditService extends _i1.Mock implements _i2.TripEditService {
  @override
  _i3.Future<void> updateTrip({
    required String? fieldName,
    required String? text,
    required _i4.DatabaseTrip? trip,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTrip,
          [],
          {
            #fieldName: fieldName,
            #text: text,
            #trip: trip,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> shareTrip({
    required _i4.DatabaseTrip? trip,
    required List<String>? message,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #shareTrip,
          [],
          {
            #trip: trip,
            #message: message,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
