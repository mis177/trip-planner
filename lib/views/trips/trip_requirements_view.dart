import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_service.dart';
import 'package:tripplanner/extensions/buildcontext/loc.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/extensions/buildcontext/get_argument.dart';
import 'package:tripplanner/utilities/dialogs/confirmation_dialog.dart';
import 'package:tripplanner/utilities/dialogs/error_dialog.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';

typedef CheckboxUpdateCallback = void Function(bool);

class RequirementsView extends StatefulWidget {
  const RequirementsView({super.key});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripRequirementBloc(
        TripRequirementService(),
      ),
      child: const RequirementsListView(),
    );
  }
}

class RequirementsListView extends StatefulWidget {
  const RequirementsListView({super.key});

  @override
  State<RequirementsListView> createState() => _RequirementsListViewState();
}

class _RequirementsListViewState extends State<RequirementsListView> {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.trip_requirements_title)),
      body: BlocConsumer<TripRequirementBloc, TripRequirementState>(
          listener: (context, state) async {
        if (state is TripRequirementAdded) {
          if (state.exception == null) {
            showSnackBar(context.loc.trip_requirements_added);
          } else {
            await showErrorDialog(
                context: context,
                content: context.loc.trip_requirements_error_add);
          }
        } else if (state is TripRequirementUpdated) {
          if (state.exception != null) {
            await showErrorDialog(
                context: context, content: context.loc.trip_costs_error_update);
            if (mounted) {
              context.read<TripRequirementBloc>().add(TripRequirementLoadAll(
                  trip: context.getArgument<DatabaseTrip>()!));
            }
          }
        } else if (state is TripRequirementDeleted) {
          if (state.exception == null) {
            showSnackBar(context.loc.trip_requirements_deleted);
          } else {
            await showErrorDialog(
                context: context,
                content: context.loc.trip_requirements_error_remove);
          }
        } else if (state is TripRequirementDeletedAll) {
          if (state.exception == null) {
            showSnackBar(context.loc.trip_requirements_deleted_all);
          } else {
            await showErrorDialog(
                context: context,
                content: context.loc.trip_requirements_error_remove_all);
          }
        } else if (state is TripRequirementLoadInProgress) {
          LoadingScreen().show(
              context: context, text: context.loc.trip_requirements_loading);
        } else if (state is TripRequirementAddInProgress) {
          LoadingScreen().show(
              context: context, text: context.loc.trip_requirements_adding);
        } else if (state is TripRequirementDeleteInProgress) {
          LoadingScreen().show(
              context: context, text: context.loc.trip_requirements_deleting);
        } else if (state is TripRequirementDeleteAllInProgress) {
          LoadingScreen().show(
              context: context,
              text: context.loc.trip_requirements_deleting_all);
        } else {
          LoadingScreen().hide();
        }
      }, builder: (context, state) {
        if (state is TripRequirementInitial) {
          context.read<TripRequirementBloc>().add(TripRequirementLoadAll(
              trip: context.getArgument<DatabaseTrip>()!));
          return const CircularProgressIndicator();
        } else if (state is TripRequirementLoaded) {
          late final width = MediaQuery.of(context).size.width;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).colorScheme.surfaceVariant),
                dataRowColor: MaterialStateColor.resolveWith((states) =>
                    Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withAlpha(100)),
                columnSpacing: 20,
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: width * 0.4,
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          context.loc.trip_requirements_requirement,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: width * 0.2,
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          context.loc.trip_requirements_done,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: width * 0.1,
                      child: IconButton(
                        onPressed: () async {
                          final shouldDelete = await showConfirmationDialog(
                            context: context,
                            title: context.loc.trip_requirements_dialog_title,
                            content:
                                context.loc.trip_requirements_dialog_content,
                          );
                          if (mounted) {
                            context
                                .read<TripRequirementBloc>()
                                .add(TripRequirementRemoveAll(
                                  trip: context.getArgument<DatabaseTrip>()!,
                                  shouldDelete: shouldDelete,
                                ));
                          }
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                    ),
                  ),
                ],
                rows: state.dataRows.map(
                  (requirement) {
                    final width = MediaQuery.of(context).size.width;
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: width * 0.4,
                            child: Center(
                              child: TextFormField(
                                initialValue: requirement.name,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: context
                                      .loc.trip_requirements_requirement_hint,
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textInputAction: TextInputAction.next,
                                onChanged: (text) async {
                                  context
                                      .read<TripRequirementBloc>()
                                      .add(TripRequirementUpdate(
                                        fieldName: 'name',
                                        text: text,
                                        trip: context
                                            .getArgument<DatabaseTrip>()!,
                                        requirement: requirement,
                                      ));
                                },
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: width * 0.2,
                            child: Checkbox(
                              value: requirement.isDone,
                              onChanged: (bool? value) {
                                requirement.isDone = value!;
                                context
                                    .read<TripRequirementBloc>()
                                    .add(TripRequirementUpdate(
                                      trip:
                                          context.getArgument<DatabaseTrip>()!,
                                      requirement: requirement,
                                      fieldName: 'is_done',
                                      text: value.toString(),
                                    ));
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: width * 0.1,
                            child: IconButton(
                              onPressed: () async {
                                context
                                    .read<TripRequirementBloc>()
                                    .add(TripRequirementRemove(
                                      trip:
                                          context.getArgument<DatabaseTrip>()!,
                                      requirement: requirement,
                                    ));
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          context.read<TripRequirementBloc>().add(
              TripRequirementAdd(trip: context.getArgument<DatabaseTrip>()!));
        },
      ),
    );
  }
}
