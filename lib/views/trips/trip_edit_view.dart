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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                await showErrorDialog(context: context, content: context.loc.trip_costs_error_update);
                if (context.mounted) {
                  context.read<TripEditBloc>().add(TripLoad(trip: context.getArgument<DatabaseTrip>()!));
                }
              }
            }
          },
          builder: (context, state) {
            if (state is TripEditInitial) {
              context.read<TripEditBloc>().add(TripLoad(trip: context.getArgument<DatabaseTrip>()!));
            } else if (state is TripEditLoaded) {
              dateController.text = state.trip!.date;

              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            initialValue: state.trip?.name,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_name_hint,
                              helperText: context.loc.trip_edit_name_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.trip_edit_name_error;
                              }
                              return null;
                            },
                            onChanged: (text) {
                              context.read<TripEditBloc>().add(TripEditUpdate(
                                    fieldName: 'name',
                                    text: text,
                                    trip: context.getArgument<DatabaseTrip>()!,
                                  ));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            initialValue: state.trip?.destination,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_destination_hint,
                              helperText: context.loc.trip_edit_destination_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: dateController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_date_hint,
                              helperText: context.loc.trip_edit_date_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onTap: () async {
                              DateTimeRange? tripDate = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 730)));

                              if (tripDate != null) {
                                dateController.text = tripDate.toString().replaceAll('00:00:00.000', '');
                                if (context.mounted) {
                                  setState(() {
                                    state.trip!.date = dateController.text;
                                    context.read<TripEditBloc>().add(TripEditUpdate(
                                          fieldName: 'date',
                                          text: dateController.text,
                                          trip: context.getArgument<DatabaseTrip>()!,
                                        ));
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            initialValue: state.trip?.note,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_notes_hint,
                              helperText: context.loc.trip_edit_notes_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_costs_hint,
                              helperText: context.loc.trip_edit_costs_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              context.read<TripEditBloc>().add(TripEditTablePress(
                                    route: tripCostRoute,
                                    trip: context.getArgument<DatabaseTrip>()!,
                                  ));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: context.loc.trip_edit_requirements_hint,
                              helperText: context.loc.trip_edit_requirements_helper,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              context.read<TripEditBloc>().add(
                                    TripEditTablePress(
                                      route: tripRequirementsRoute,
                                      trip: context.getArgument<DatabaseTrip>()!,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context);
          }
        },
        backgroundColor: theme.colorScheme.secondary,
        child: const Icon(Icons.check),
      ),
    );
  }
}
