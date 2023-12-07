import 'package:flutter/material.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/services/crud/database_trip_provider.dart';
import 'package:tripplanner/views/trips/trip_edit_view.dart';
import 'package:tripplanner/views/trips/trip_cost_view.dart';
import 'package:tripplanner/views/trips/trip_requirements_view.dart';
import 'package:tripplanner/views/trips/trips_list_view.dart';

void main() {
  runApp(const MyApp());
  DatabaseTripsProvider service = DatabaseTripsProvider();
  service.openDb();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        tripEditRoute: (context) => const TripView(),
        tripCostRoute: (context) => const CostsView(),
        tripRequirementsRoute: (context) => const RequirementsView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TripsView();
  }
}
