import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_bloc.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_event.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_state.dart';
import 'package:tripplanner/bloc/trip_edit/trip_edit_service.dart';
import 'package:tripplanner/const/routes.dart';
import 'package:tripplanner/extensions/buildcontext/loc.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/extensions/buildcontext/get_argument.dart';
import 'package:tripplanner/utilities/dialogs/error_dialog.dart';

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
        TripEditService(),
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
        title: Text(context.loc.trip_edit_title),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TripEditBloc>().add(TripEditSharePress(
                    trip: context.getArgument<DatabaseTrip>()!,
                    message: [
                      context.loc.trip_edit_share_name,
                      context.loc.trip_edit_share_planned_cost,
                      context.loc.trip_edit_share_real_cost,
                      context.loc.trip_edit_share_done,
                      context.loc.trip_edit_share_title,
                      context.loc.trip_edit_share_destination,
                      context.loc.trip_edit_share_date,
                      context.loc.trip_edit_share_note,
                      context.loc.trip_edit_share_costs,
                      context.loc.trip_edit_share_requirements,
                    ],
                  ));
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<TripEditBloc, TripEditState>(
          listener: (context, state) async {
            if (state is TripEditTableSelected) {
              Navigator.of(context).pushNamed(
                state.route,
                arguments: state.trip,
              );
            } else if (state is TripEditUpdated) {
              if (state.exception != null) {
                await showErrorDialog(
                    context: context,
                    content: context.loc.trip_costs_error_update);
                if (mounted) {
                  context.read<TripEditBloc>().add(
                      TripLoad(trip: context.getArgument<DatabaseTrip>()!));
                }
              }
            }
          },
          builder: (context, state) {
            if (state is TripEditInitial) {
              context
                  .read<TripEditBloc>()
                  .add(TripLoad(trip: context.getArgument<DatabaseTrip>()!));
            } else if (state is TripEditLoaded) {
              dateController.text = state.trip!.date;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Card(
                      child: TextFormField(
                        initialValue: state.trip?.name,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.abc),
                          border: InputBorder.none,
                          label: Text(context.loc.trip_edit_name_helper),
                          hintText: context.loc.trip_edit_name_hint,
                        ),
                        onChanged: (text) {
                          context.read<TripEditBloc>().add(TripEditUpdate(
                                fieldName: 'name',
                                text: text,
                                trip: context.getArgument<DatabaseTrip>()!,
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      child: TextFormField(
                        initialValue: state.trip?.destination,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.add_location),
                          border: InputBorder.none,
                          label: Text(context.loc.trip_edit_destination_helper),
                          hintText: context.loc.trip_edit_destination_hint,
                        ),
                        onChanged: (text) {
                          context.read<TripEditBloc>().add(TripEditUpdate(
                                fieldName: 'destination',
                                text: text,
                                trip: context.getArgument<DatabaseTrip>()!,
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      child: TextField(
                        controller: dateController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.date_range),
                          border: InputBorder.none,
                          label: Text(context.loc.trip_edit_date_helper),
                          hintText: context.loc.trip_edit_date_hint,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTimeRange? tripDate = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 730)));

                          if (tripDate != null) {
                            dateController.text = tripDate
                                .toString()
                                .replaceAll('00:00:00.000', '');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      child: TextFormField(
                        initialValue: state.trip?.note,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.note),
                          border: InputBorder.none,
                          label: Text(context.loc.trip_edit_notes_helper),
                          hintText: context.loc.trip_edit_notes_hint,
                        ),
                        onChanged: (text) {
                          context.read<TripEditBloc>().add(TripEditUpdate(
                                fieldName: 'note',
                                text: text,
                                trip: context.getArgument<DatabaseTrip>()!,
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                            child: Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<TripEditBloc>()
                                      .add(TripEditTablePress(
                                        route: tripCostRoute,
                                        trip: context
                                            .getArgument<DatabaseTrip>()!,
                                      ));
                                },
                                child: Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.attach_money_rounded),
                                      border: InputBorder.none,
                                      label: Text(
                                        textAlign: TextAlign.center,
                                        context.loc.trip_edit_costs_hint,
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                            child: Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  context.read<TripEditBloc>().add(
                                        TripEditTablePress(
                                          route: tripRequirementsRoute,
                                          trip: context
                                              .getArgument<DatabaseTrip>()!,
                                        ),
                                      );
                                },
                                child: Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.check_box),
                                      border: InputBorder.none,
                                      label: Center(
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            context.loc
                                                .trip_edit_requirements_hint),
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
