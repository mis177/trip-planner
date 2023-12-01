import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tripplanner/services/crud/trips_service.dart';
import 'package:tripplanner/utilities/get_argument.dart';

typedef CheckboxUpdateCallback = void Function(bool);

class RequirementsView extends StatefulWidget {
  const RequirementsView({super.key});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  List<bool> checkboxes = [];
  List<DataRow> dataRows = [];
  late DatabaseTrip _trip;
  final Map<int, TextEditingController> _textControllers = {};
  late final TripsService _tripsService;
  late final _width = MediaQuery.of(context).size.width;

  @override
  void initState() {
    _tripsService = TripsService();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void loadExistingRequirements() async {
    if (_trip.requirements.isNotEmpty) {
      for (var previousRequirement in _trip.requirements) {
        dataRows.add(
          createRow(previousRequirement),
        );
      }
    }
  }

  Future<void> updateRequirements(
    DatabaseRequirement requirement,
    String fieldName,
    value,
  ) async {
    await _tripsService.updateRequirement(
      requirement,
      fieldName,
      value,
    );
  }

  DataRow createRow(
    DatabaseRequirement newRequirement,
  ) {
    final requirement = newRequirement;
    TextEditingController requirementTextController = TextEditingController();
    requirementTextController.text = requirement.name;
    _textControllers[requirement.id] = requirementTextController;
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            //width: width * 0.35,
            child: TextField(
              controller: requirementTextController,
              decoration: const InputDecoration(
                hintText: 'requirement',
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                await updateRequirements(
                  requirement,
                  'name',
                  text,
                );
              },
            ),
          ),
        ),
        DataCell(
          MyCheckbox(
            onCheckboxUpdate: (isChecked) async {
              await updateRequirements(
                requirement,
                'is_done',
                isChecked == false ? 0 : 1,
              );
            },
            requirement: requirement,
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
      loadExistingRequirements();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: SingleChildScrollView(
          child: DataTable(
        columns: const [
          DataColumn(
            label: Expanded(
              child: Text(
                'Requirement',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Done',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
        rows: dataRows,
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          DatabaseRequirement newRequirement =
              await _tripsService.addRequirement(_trip.id);
          setState(
            () {
              dataRows.add(
                createRow(newRequirement),
              );
            },
          );
        },
      ),
    );
  }
}

class MyCheckbox extends StatefulWidget {
  MyCheckbox(
      {super.key, required this.onCheckboxUpdate, required this.requirement});
  final CheckboxUpdateCallback onCheckboxUpdate;
  final DatabaseRequirement requirement;
  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.green,
      value: widget.requirement.isDone,
      onChanged: (bool? value) {
        setState(() {
          widget.requirement.isDone = value!;
          widget.onCheckboxUpdate(widget.requirement.isDone);
        });
      },
    );
  }
}
