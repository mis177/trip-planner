import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_bloc.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_event.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirement_state.dart';
import 'package:tripplanner/bloc/trip_requirement/trip_requirements_utils.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/get_argument.dart';
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
        TripRequirementUtils(),
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
        backgroundColor: Colors.green,
        content: Text(text),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripRequirementBloc, TripRequirementState>(
        listener: (context, state) {
      if (state is TripRequirementAddSuccess) {
        showSnackBar('Requirement added');
      } else if (state is TripRequirementDeleteSuccess) {
        showSnackBar('Requirement deleted');
      } else if (state is TripRequirementDeleteAllSuccess) {
        showSnackBar('All requirements deleted');
      }

      if (state.isLoading) {
        LoadingScreen().show(context: context, text: state.loadingText);
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is TripRequirementInitial) {
        context.read<TripRequirementBloc>().add(
            TripRequirementLoadAll(trip: context.getArgument<DatabaseTrip>()!));
        return const CircularProgressIndicator();
      } else if (state is TripRequirementLoadSuccess) {
        late final width = MediaQuery.of(context).size.width;

        return Scaffold(
          appBar: AppBar(title: const Text('Requirements')),
          body: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: width * 0.5,
                    child: const Center(
                      child: Text(
                        'Requirement',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.2,
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.1,
                    child: IconButton(
                      onPressed: () async {
                        context.read<TripRequirementBloc>().add(
                            TripRequirementRemoveAll(
                                trip: context.getArgument<DatabaseTrip>()!));
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
                          width: width * 0.5,
                          child: Center(
                            child: TextFormField(
                              initialValue: requirement.name,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'requirement',
                                border: UnderlineInputBorder(),
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
                                      trip:
                                          context.getArgument<DatabaseTrip>()!,
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
                            activeColor: Colors.green,
                            value: requirement.isDone,
                            onChanged: (bool? value) {
                              print(value);
                              requirement.isDone = value!;
                              context
                                  .read<TripRequirementBloc>()
                                  .add(TripRequirementUpdate(
                                    trip: context.getArgument<DatabaseTrip>()!,
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
                                    trip: context.getArgument<DatabaseTrip>()!,
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
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              context.read<TripRequirementBloc>().add(TripRequirementAdd(
                  trip: context.getArgument<DatabaseTrip>()!));
            },
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}
