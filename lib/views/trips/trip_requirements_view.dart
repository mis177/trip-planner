import 'package:flutter/material.dart';

class RequirementsView extends StatefulWidget {
  const RequirementsView({super.key});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  List<bool> checkboxes = [];
  List<DataRow> dataRows = [];
  final List<TextEditingController> _textControllers = [];

  DataRow createRow(
    BuildContext context,
  ) {
    TextEditingController requirementTextController = TextEditingController();
    _textControllers.add(requirementTextController);
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
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (text) async {
                //await updateCost('activity', text, cost);
              },
            ),
          ),
        ),
        const DataCell(MyCheckbox()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: InteractiveViewer(
          constrained: false,
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
          // DatabaseCost newCost = await _tripsService.addCost(_trip.id);
          setState(
            () {
              dataRows.add(
                createRow(
                  context,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.green,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
