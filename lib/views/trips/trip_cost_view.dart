import 'dart:async';

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
  final Map<int, List<TextEditingController>> _textControllers = {};
  late DatabaseTrip _trip;
  late final TripsService _tripsService;
  late final _width = MediaQuery.of(context).size.width;

  @override
  void initState() {
    _tripsService = TripsService();
    super.initState();
  }

  @override
  void dispose() {
    for (var controllers in _textControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void loadExistingCosts() async {
    if (_trip.costs.isNotEmpty) {
      for (var previousCost in _trip.costs) {
        dataRows.add(
          createRow(previousCost),
        );
      }
    }
  }

  Future<void> updateCost(
      String fieldName, String text, DatabaseCost cost) async {
    await _tripsService.updateCost(
      cost,
      fieldName,
      text,
    );
  }

  Future<void> deleteCost(DatabaseCost cost) async {
    await _tripsService.deleteCost(cost);
    for (var controller in _textControllers[cost.id]!) {
      controller.dispose();
      _textControllers.remove(cost.id);
    }
    dataRows = [];
  }

  Future<void> deleteAllCosts() async {
    List<DatabaseCost> toRemove = [];
    for (var cost in _trip.costs) {
      toRemove.add(cost);
    }
    for (var cost in toRemove) {
      await _tripsService.deleteCost(cost);
    }
    for (var controllers in _textControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    _textControllers.clear();
    dataRows = [];
    setState(
      () {},
    );
  }

  DataRow createRow(
    DatabaseCost newCost,
  ) {
    final cost = newCost;

    TextEditingController activityNameTextController = TextEditingController();
    activityNameTextController.text = cost.activity;
    TextEditingController plannedCostTextController = TextEditingController();
    plannedCostTextController.text =
        cost.planned.isNaN ? '' : cost.planned.toString();
    TextEditingController realCostTextController = TextEditingController();
    realCostTextController.text = cost.real.isNaN ? '' : cost.real.toString();
    _textControllers[newCost.id] = [
      activityNameTextController,
      plannedCostTextController,
      realCostTextController
    ];

    double plannedCost =
        double.tryParse(plannedCostTextController.text) ?? double.nan;
    double realCost =
        double.tryParse(realCostTextController.text) ?? double.nan;

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: _width * 0.3,
            child: TextField(
              controller: activityNameTextController,
              decoration: const InputDecoration(
                hintText: 'Activity name',
                border: UnderlineInputBorder(),
              ),
              //autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                await updateCost('name', text, cost);
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: _width * 0.15,
            child: TextField(
              controller: plannedCostTextController,
              decoration: const InputDecoration(hintText: 'Planned'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                plannedCost = double.tryParse(text) ?? double.nan;
                await updateCost(
                  'planned',
                  text,
                  cost,
                );
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: _width * 0.15,
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
                await updateCost(
                  'real',
                  text,
                  cost,
                );
              },
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: _width * 0.1,
            child: IconButton(
              onPressed: () async {
                await deleteCost(cost);
                setState(() {});
              },
              icon: const Icon(Icons.delete),
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
    if (dataRows.isEmpty) {
      loadExistingCosts();
    }
    final width = MediaQuery.of(context).size.width;
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
                child: const Text(
                  'Activity',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: width * 0.15,
                child: const Text(
                  'Planned',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: SizedBox(
                width: width * 0.15,
                child: const Text(
                  'Real',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: width * 0.1,
                child: IconButton(
                  onPressed: () async {
                    deleteAllCosts();
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
            ),
          ],
          rows: dataRows,
        ),
      ),
      //  CostsListView(
      //   dataRows: dataRows,
      //   onDeleteAll: deleteAllCosts,
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          DatabaseCost newCost = await _tripsService.addCost(_trip.id);
          setState(
            () {
              dataRows.add(
                createRow(newCost),
              );
            },
          );
        },
      ),
    );
  }
}
