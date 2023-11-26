import 'package:flutter/material.dart';

class CostView extends StatefulWidget {
  const CostView({super.key});

  @override
  State<CostView> createState() => _CostViewState();
}

class _CostViewState extends State<CostView> {
  @override
  Widget build(BuildContext context) {
    //final widgetTrip = context.getArgument<DatabaseTrip>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip costs'),
      ),
      body: const CostTable(),
    );
  }
}

class CostTable extends StatefulWidget {
  const CostTable({super.key});

  @override
  State<CostTable> createState() => _CostTableState();
}

class _CostTableState extends State<CostTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(columns: const [
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
            'Planned cost',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Real cost',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    ], rows: const [
      DataRow(
        cells: [
          DataCell(
            TextField(
              decoration: InputDecoration.collapsed(hintText: 'Username'),
            ),
          ),
          DataCell(TextField()),
          DataCell(TextField()),
        ],
      ),
    ]);
  }
}

DataRow createRow() {
  return const DataRow(
    cells: [
      DataCell(
        TextField(
          decoration: InputDecoration.collapsed(hintText: 'Username'),
        ),
      ),
      DataCell(TextField()),
      DataCell(TextField()),
    ],
  );
}
