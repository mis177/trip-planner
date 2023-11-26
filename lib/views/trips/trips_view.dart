import 'package:flutter/material.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/services/crud/trips_service.dart';
import 'package:tripplanner/views/trips/trips_list_view.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  late final TripsService _tripsService;

  @override
  void initState() {
    _tripsService = TripsService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Trips"),
        actions: [
          IconButton(
            onPressed: () async {
              //await _tripsService.addTrip();
              Navigator.of(context).pushNamed(createOrUpdateTripRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _tripsService.allTrips,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTrips = snapshot.data as List<DatabaseTrip>;
                return TripsListView(
                  trips: allTrips,
                  onDeleteTrip: (trip) async {
                    await _tripsService.deleteTrip(trip);
                  },
                  onTapTrip: (trip) async {
                    Navigator.of(context).pushNamed(
                      createOrUpdateTripRoute,
                      arguments: trip,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
