import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_event.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_state.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_utils.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/get_argument.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';

typedef TripUpdateCallback = void Function()?;

class TripView extends StatefulWidget {
  const TripView({super.key});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripEditBloc(
        TripEditUtils(),
      ),
      child: const EditTripView(),
    );
  }
}

class EditTripView extends StatefulWidget {
  const EditTripView({super.key});

  @override
  State<EditTripView> createState() => _EditTripViewState();
}

class _EditTripViewState extends State<EditTripView> {
  late final TextEditingController dateController;
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(text),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void initState() {
    dateController = TextEditingController();
    dateController.addListener(() {
      context.read<TripEditBloc>().add(TripEditUpdate(
            fieldName: 'date',
            text: dateController.text,
            trip: context.getArgument<DatabaseTrip>()!,
          ));
    });
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your trip'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TripEditBloc>().add(TripEditSharePressed(
                  trip: context.getArgument<DatabaseTrip>()!));
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: BlocConsumer<TripEditBloc, TripEditState>(
        listener: (context, state) {
          if (state is TripEditTableSelect) {
            Navigator.of(context).pushNamed(
              state.route,
              arguments: state.trip,
            );
          }

          if (state.isLoading) {
            LoadingScreen().show(context: context, text: state.loadingText);
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is TripEditInitial) {
            context
                .read<TripEditBloc>()
                .add(TripLoad(trip: context.getArgument<DatabaseTrip>()!));
          } else if (state is TripEditLoadSuccess) {
            dateController.text = state.trip!.date;
            return Column(
              children: [
                TextFormField(
                  initialValue: state.trip?.name,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Name of a trip',
                    helperText: 'Name of your trip',
                  ),
                  onChanged: (text) {
                    context.read<TripEditBloc>().add(TripEditUpdate(
                          fieldName: 'name',
                          text: text,
                          trip: context.getArgument<DatabaseTrip>()!,
                        ));
                  },
                ),
                TextFormField(
                  initialValue: state.trip?.destination,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Trip destination',
                    helperText: 'Destination of your trip',
                  ),
                  onChanged: (text) {
                    context.read<TripEditBloc>().add(TripEditUpdate(
                          fieldName: 'destination',
                          text: text,
                          trip: context.getArgument<DatabaseTrip>()!,
                        ));
                  },
                ),
                TextField(
                  //     initialValue: state.trip?.date,
                  controller: dateController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Trip date',
                    helperText: 'Date of your trip',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTimeRange? tripDate = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 730)));

                    if (tripDate != null) {
                      dateController.text =
                          tripDate.toString().replaceAll('00:00:00.000', '');
                    }
                  },
                ),
                TextFormField(
                  initialValue: state.trip?.note,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'My notes',
                    helperText: 'Your notes',
                  ),
                  onChanged: (text) {
                    context.read<TripEditBloc>().add(TripEditUpdate(
                          fieldName: 'note',
                          text: text,
                          trip: context.getArgument<DatabaseTrip>()!,
                        ));
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Trip costs [.....]',
                    helperText: 'Cost of your trip',
                  ),
                  readOnly: true,
                  onTap: () {
                    context.read<TripEditBloc>().add(TripEditTablePressed(
                          route: tripCostRoute,
                          trip: context.getArgument<DatabaseTrip>()!,
                        ));
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Trip requirements [.....]',
                    helperText: 'Requirements before your trip',
                  ),
                  readOnly: true,
                  onTap: () {
                    context.read<TripEditBloc>().add(
                          TripEditTablePressed(
                            route: tripRequirementsRoute,
                            trip: context.getArgument<DatabaseTrip>()!,
                          ),
                        );
                  },
                ),
              ],
            );
          }
          return const Text('Error');
        },
      ),
    );
  }
}
