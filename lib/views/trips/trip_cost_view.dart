import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_bloc.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_event.dart';
import 'package:tripplanner/bloc/trip_cost/trip_cost_state.dart';
import 'package:tripplanner/models/trips.dart';
import 'package:tripplanner/utilities/get_argument.dart';
import 'package:tripplanner/utilities/loading_screen/loading_screen.dart';
import 'package:tripplanner/bloc/trip_cost/trip_costs_utils.dart';

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
    return BlocConsumer<TripCostBloc, TripCostState>(
        listener: (context, state) {
      if (state is TripCostAddSuccess) {
        showSnackBar('Cost added');
      } else if (state is TripCostDeleteSuccess) {
        showSnackBar('Cost deleted');
      } else if (state is TripCostDeleteAllSuccess) {
        showSnackBar('All costs deleted');
      }

      if (state.isLoading) {
        LoadingScreen().show(context: context, text: state.loadingText);
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is TripCostInitial) {
        context
            .read<TripCostBloc>()
            .add(TripCostLoadAll(trip: context.getArgument<DatabaseTrip>()!));
        return const CircularProgressIndicator();
      } else if (state is TripCostLoadSuccess) {
        late final width = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Trip costs'),
          ),
          body: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: width * 0.3,
                    child: const Center(
                      child: Text(
                        'Activity',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.15,
                    child: const Center(
                      child: Text(
                        'Planned',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: SizedBox(
                    width: width * 0.15,
                    child: const Center(
                      child: Text(
                        'Real',
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
                        context.read<TripCostBloc>().add(TripCostRemoveAll(
                            trip: context.getArgument<DatabaseTrip>()!));
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
                            decoration: const InputDecoration(
                              hintText: 'Activity name',
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textInputAction: TextInputAction.next,
                            onChanged: (text) {
                              context.read<TripCostBloc>().add(TripCostUpdate(
                                    fieldName: 'name',
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
                                      fieldName: 'planned',
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
                                    fieldName: 'real',
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
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              context
                  .read<TripCostBloc>()
                  .add(TripCostAdd(trip: context.getArgument<DatabaseTrip>()!));
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
