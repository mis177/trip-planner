import 'package:flutter/material.dart';
import 'package:tripplanner/services/crud/trips_service.dart';
import 'package:tripplanner/utilities/get_argument.dart';

class CostView extends StatefulWidget {
  const CostView({super.key});

  @override
  State<CostView> createState() => _CostViewState();
}

class _CostViewState extends State<CostView> {
  List<DataRow> dataRows = [];
  final List<TextEditingController> _textControllers = [];
  late DatabaseTrip _trip;
  // late DatabaseCost _cost;
  late final TripsService _tripsService;
  bool firstRun = true;

  @override
  void initState() {
    _tripsService = TripsService();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> firstOpen(
    BuildContext context,
  ) async {
    if (firstRun) {
      final trip = _trip;
      if (trip.costs.isNotEmpty) {
        for (var previousCost in trip.costs) {
          dataRows.add(
            createRow(
              context,
              previousCost,
            ),
          );
        }
      } else {
        DatabaseCost newCost = await _tripsService.addCost(trip.id);
        dataRows.add(
          // ignore: use_build_context_synchronously
          createRow(
            context,
            newCost,
          ),
        );
      }
    }
    firstRun = false;
  }

  Future<void> updateCost(
      String fieldName, String text, DatabaseCost cost) async {
    final service = _tripsService;
    await service.updateCost(
      cost,
      fieldName,
      text,
    );
  }

  DataRow createRow(BuildContext context, DatabaseCost newCost) {
    final cost = newCost;

    final width = MediaQuery.of(context).size.width;
    TextEditingController activityNameTextController = TextEditingController();
    activityNameTextController.text = cost.activity;
    TextEditingController plannedCostTextController = TextEditingController();
    plannedCostTextController.text =
        cost.planned.isNaN ? '' : cost.planned.toString();
    TextEditingController realCostTextController = TextEditingController();
    realCostTextController.text = cost.real.isNaN ? '' : cost.real.toString();

    double plannedCost =
        double.tryParse(plannedCostTextController.text) ?? double.nan;
    double realCost =
        double.tryParse(realCostTextController.text) ?? double.nan;

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: width * 0.35,
            child: TextField(
              controller: activityNameTextController,
              decoration: const InputDecoration(
                hintText: 'Activity name',
                border: UnderlineInputBorder(),
              ),
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                await updateCost('activity', text, cost);
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: width * 0.2,
            child: TextField(
              controller: plannedCostTextController,
              decoration: const InputDecoration(hintText: 'Planned'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                plannedCost = double.tryParse(text) ?? double.nan;
                await updateCost('planned', text, cost);
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: width * 0.2,
            child: TextField(
              controller: realCostTextController,
              decoration: InputDecoration(
                hintText: 'Real',
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
              onChanged: (text) async {
                realCost = double.tryParse(text) ?? double.nan;
                await updateCost('real', text, cost);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgetTrip = context.getArgument<DatabaseTrip>();
    if (widgetTrip != null) {
      _trip = widgetTrip;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip costs'),
      ),
      body: FutureBuilder(
        future: firstOpen(context),
        builder: (context, snapshot) {
          return InteractiveViewer(
            constrained: false,
            child: DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Activity',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Planned',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Real',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: dataRows,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DatabaseCost newCost = await _tripsService.addCost(_trip.id);
          setState(
            () {
              dataRows.add(
                createRow(context, newCost),
              );
            },
          );
        },
      ),
    );
  }
}
