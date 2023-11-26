import 'package:flutter/material.dart';

class CostView extends StatefulWidget {
  const CostView({super.key});

  @override
  State<CostView> createState() => _CostViewState();
}

class _CostViewState extends State<CostView> {
  List<DataRow> dataRows = [];
  @override
  Widget build(BuildContext context) {
    //final widgetTrip = context.getArgument<DatabaseTrip>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trip costs'),
        ),
        body: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(
              label: Text(
                'Activity',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Planned cost',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Real cost',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: dataRows,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(
            () {
              dataRows.add(
                createRow(context),
              );
            },
          );
        }));
  }
}

DataRow createRow(BuildContext context) {
  //final renderBox = context.findRenderObject() as RenderBox;
  final width = MediaQuery.of(context).size.width;
  double? plannedCost;
  double? realCost;
  return DataRow(
    cells: [
      DataCell(
        SizedBox(
          width: width * 0.4,
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Activity name',
              border: UnderlineInputBorder(),
            ),
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.next,
          ),
        ),
      ),
      DataCell(
        TextField(
            decoration: const InputDecoration(hintText: 'Planned'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              plannedCost = double.tryParse(text);
            }),
      ),
      DataCell(
        TextField(
          decoration: InputDecoration(
            hintText: 'Real',
            filled: true,
            fillColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (realCost == null || plannedCost == null) {
                return Colors.transparent;
              } else {
                if (realCost! < plannedCost!) {
                  return Colors.green.shade200;
                } else {
                  return Colors.red.shade200;
                }
              }
            }),
          ),
          keyboardType: TextInputType.number,
          onChanged: (text) {
            realCost = double.tryParse(text);
          },
        ),
      ),
    ],
  );
}
