import 'package:flutter/material.dart';
import 'package:tripplanner/services/crud/trips_service.dart';

typedef TripCallback = void Function(DatabaseTrip trip);

class TripsListView extends StatelessWidget {
  final List<DatabaseTrip> trips;
  final TripCallback onDeleteTrip;
  final TripCallback onTapTrip;

  const TripsListView(
      {required this.trips,
      required this.onDeleteTrip,
      required this.onTapTrip,
      super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips.elementAt(index);
        return ListTile(
          title: Text(
            trip.name,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDeleteTrip(trip);
            },
          ),
          onTap: () {
            onTapTrip(trip);
          },
        );
      },
    );
  }
}
