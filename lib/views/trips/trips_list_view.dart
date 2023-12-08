import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_utils.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_bloc.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_event.dart';
import 'package:tripplanner/bloc/trip_list/trip_list_state.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';

typedef TripCallback = void Function(DatabaseTrip trip);

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripListBloc(
        TripListUtils(),
      ),
      child: const TripsListView(),
    );
  }
}

class TripsListView extends StatefulWidget {
  const TripsListView({super.key});

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(text),
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Trips"),
          actions: [
            IconButton(
              onPressed: () async {
                context.read<TripListBloc>().add(
                      const TripListAdd(),
                    );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocConsumer<TripListBloc, TripListState>(
          listener: (context, state) {
            if (state is TripListAddSuccess) {
              Navigator.of(context)
                  .pushNamed(
                    state.route,
                    arguments: state.trip,
                  )
                  .then((value) => context.read<TripListBloc>().add(
                        const TripListLoadAll(),
                      ));
            } else if (state is TripListClicked) {
              Navigator.of(context)
                  .pushNamed(
                    state.route,
                    arguments: state.trip,
                  )
                  .then((value) => context.read<TripListBloc>().add(
                        const TripListLoadAll(),
                      ));
            } else if (state is TripListRemoveSuccess) {
              showSnackBar('Trip removed');
            }

            if (state.isLoading) {
              LoadingScreen().show(context: context, text: state.loadingText);
            } else {
              LoadingScreen().hide();
            }
          },
          builder: (context, state) {
            if (state is TripListInitial) {
              context.read<TripListBloc>().add(
                    const TripListLoadAll(),
                  );
            }

            return ListView.builder(
              itemCount: state.allTrips.length,
              itemBuilder: (context, index) {
                final trip = state.allTrips.elementAt(index);
                return ListTile(
                  title: Text(
                    trip.name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      context.read<TripListBloc>().add(
                            TripListRemove(trip: trip, context: context),
                          );
                    },
                  ),
                  onTap: () {
                    context.read<TripListBloc>().add(
                          TripListTripClick(trip: trip),
                        );
                  },
                );
              },
            );
          },
        ));
  }
}
