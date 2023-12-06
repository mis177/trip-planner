// import 'package:flutter/material.dart';
// import 'package:tripplanner/const/routes.dart';
// import 'package:tripplanner/models/trips.dart';
// import 'package:tripplanner/services/crud/database_trip_provider.dart';
// import 'package:tripplanner/utilities/get_argument.dart';

// typedef TripUpdateCallback = void Function()?;

// class EditTrip extends StatefulWidget {
//   const EditTrip({super.key});

//   @override
//   State<EditTrip> createState() => _EditTripState();
// }

// class _EditTripState extends State<EditTrip> {
//   late final DatabaseTripsProvider _tripsService;

//   _EditTripState();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Your trip')),
//       body: FutureBuilder(
//         future: getOrCreateTrip(context),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               _setupTextControllerListener();
//               return Column(
//                 children: [
//                   TextField(
//                     controller: _nameTextController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Name of a trip',
//                       helperText: 'Name of your trip',
//                     ),
//                   ),
//                   TextField(
//                     controller: _destinationTextController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Trip destination',
//                       helperText: 'Destination of your trip',
//                     ),
//                   ),
//                   TextField(
//                     controller: _dateTextController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'Trip date',
//                       helperText: 'Date of your trip',
//                     ),
//                   ),
//                   TextField(
//                     controller: _noteTextController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     decoration: const InputDecoration(
//                       hintText: 'My notes',
//                       helperText: 'Your notes',
//                     ),
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(
//                       hintText: 'Trip costs [.....]',
//                       helperText: 'Cost of your trip',
//                     ),
//                     readOnly: true,
//                     onTap: () {
//                       Navigator.of(context).pushNamed(
//                         tripCostRoute,
//                         arguments: _trip,
//                       );
//                     },
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(
//                       hintText: 'Trip requirements [.....]',
//                       helperText: 'Requirements before your trip',
//                     ),
//                     readOnly: true,
//                     onTap: () {
//                       Navigator.of(context).pushNamed(
//                         tripRequirementsRoute,
//                         arguments: _trip,
//                       );
//                     },
//                   ),
//                 ],
//               );
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
