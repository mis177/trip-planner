import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_bloc.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/get_argument.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_utils.dart';
import 'package:tripplanner/extensions/buildcontext/loc.dart';

class CostsView extends StatefulWidget {
  const CostsView({super.key});

  @override
  State<CostsView> createState() => _CostsViewState();
}

class _CostsViewState extends State<CostsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCostBloc(
        TripCostUtils(),
      ),
      child: const CostsListView(),
    );
  }
}

class CostsListView extends StatefulWidget {
  const CostsListView({super.key});

  @override
  State<CostsListView> createState() => _CostsListViewState();
}

class _CostsListViewState extends State<CostsListView> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.trip_costs_title),
      ),
      body:
          BlocConsumer<TripCostBloc, TripCostState>(listener: (context, state) {
        if (state is TripCostAddSuccess) {
          showSnackBar(context.loc.trip_costs_added);
        } else if (state is TripCostDeleteSuccess) {
          showSnackBar(context.loc.trip_costs_deleted);
        } else if (state is TripCostDeleteAllSuccess) {
          showSnackBar(context.loc.trip_costs_deleted_all);
        } else if (state is TripCostLoadInProgress) {
          LoadingScreen()
              .show(context: context, text: context.loc.trip_costs_loading);
        } else if (state is TripCostAddInProgress) {
          LoadingScreen()
              .show(context: context, text: context.loc.trip_costs_adding);
        } else if (state is TripCostDeleteInProgress) {
          LoadingScreen()
              .show(context: context, text: context.loc.trip_costs_deleting);
        } else if (state is TripCostDeleteAllInProgress) {
          LoadingScreen().show(
              context: context, text: context.loc.trip_costs_deleting_all);
        } else {
          LoadingScreen().hide();
        }

        // if (state.isLoading) {
        //   LoadingScreen().show(context: context, text: state.loadingText);
        // } else {
        //   LoadingScreen().hide();
        // }
      }, builder: (context, state) {
        if (state is TripCostInitial) {
          context
              .read<TripCostBloc>()
              .add(TripCostLoadAll(trip: context.getArgument<DatabaseTrip>()!));
        } else if (state is TripCostLoadSuccess) {
          late final width = MediaQuery.of(context).size.width;

          return SingleChildScrollView(
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: width * 0.3,
                    child: Center(
                      child: Text(
                        context.loc.trip_costs_activity,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.15,
                    child: Center(
                      child: Text(
                        context.loc.trip_costs_planned,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.15,
                    child: Center(
                      child: Text(
                        context.loc.trip_costs_real,
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
                        context.read<TripCostBloc>().add(TripCostRemoveAll(
                              trip: context.getArgument<DatabaseTrip>()!,
                              context: context,
                              dialogTitle: context.loc.trip_costs_delete,
                              dialogContent:
                                  context.loc.trip_costs_delete_content,
                            ));
                      },
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ),
                ),
              ],
              rows: state.dataRows.map(
                (cost) {
                  double plannedCost = cost.planned;
                  double realCost = cost.real;

                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: width * 0.3,
                          child: TextFormField(
                            initialValue: cost.activity,
                            decoration: InputDecoration(
                              hintText: context.loc.trip_costs_activity_hint,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textInputAction: TextInputAction.next,
                            onChanged: (text) {
                              context.read<TripCostBloc>().add(TripCostUpdate(
                                    fieldName: "name",
                                    text: text,
                                    cost: cost,
                                    trip: context.getArgument<DatabaseTrip>()!,
                                  ));
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: width * 0.15,
                          child: Center(
                            child: TextFormField(
                              initialValue: cost.planned.isNaN
                                  ? ''
                                  : cost.planned.toString(),
                              keyboardType: TextInputType.number,
                              // controller: plannedCostTextController,
                              decoration: const InputDecoration(
                                hintText: '...',
                              ),
                              textInputAction: TextInputAction.next,
                              onChanged: (text) {
                                plannedCost =
                                    double.tryParse(text) ?? double.nan;
                                context.read<TripCostBloc>().add(TripCostUpdate(
                                      fieldName: "planned",
                                      text: text,
                                      cost: cost,
                                      trip:
                                          context.getArgument<DatabaseTrip>()!,
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: width * 0.15,
                          child: TextFormField(
                            initialValue:
                                cost.real.isNaN ? '' : cost.real.toString(),
                            onChanged: (text) {
                              realCost = double.tryParse(text) ?? double.nan;
                              context.read<TripCostBloc>().add(TripCostUpdate(
                                    fieldName: "real",
                                    text: text,
                                    cost: cost,
                                    trip: context.getArgument<DatabaseTrip>()!,
                                  ));
                            },
                            decoration: InputDecoration(
                              hintText: '...',
                              filled: true,
                              fillColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                                  if (realCost.isNaN || plannedCost.isNaN) {
                                    return Colors.transparent;
                                  } else {
                                    if (realCost <= plannedCost) {
                                      return Colors.green.shade200;
                                    } else {
                                      return Colors.red.shade200;
                                    }
                                  }
                                },
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: width * 0.1,
                          child: IconButton(
                            onPressed: () async {
                              context.read<TripCostBloc>().add(TripCostRemove(
                                    cost: cost,
                                    trip: context.getArgument<DatabaseTrip>()!,
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
          );
        }
        return const CircularProgressIndicator();
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          context
              .read<TripCostBloc>()
              .add(TripCostAdd(trip: context.getArgument<DatabaseTrip>()!));
        },
      ),
    );
  }
}
