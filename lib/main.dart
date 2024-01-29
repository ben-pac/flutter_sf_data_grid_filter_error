import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'group.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion filter strongDataType error',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Error demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Data {
  Group group;
  String other;

  Data(this.group, this.other);
}

class MyGroupSource extends DataGridSource {

  final List<Group> groups;
  List<Data> _data = [];

  MyGroupSource(this.groups) {
    _data = [for (var i =0; i < 30; i++)
      Data(faker.randomGenerator.element(groups), "Data $i"),];
  }

  @override
  List<DataGridRow> get rows {
    return [
      for (var data in _data)
        DataGridRow(cells: [
          DataGridCell<Group>(columnName: "group", value: data.group),
          DataGridCell<String>(columnName: "other", value: data.other),
        ]),
    ];
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return  DataGridRowAdapter(
        cells: row.getCells().map((dataCell) {
          if (dataCell.value is Group) {
            return Container(color: Colors.orange[600], child: Text((dataCell.value as Group).name));
          }
          return Container(
            alignment: Alignment.center,
            child: Text(dataCell.value.toString()),
          );
        }).toList());
  }

}


class _MyHomePageState extends State<MyHomePage> {

  final MyGroupSource _source = MyGroupSource([
    Group(1, "group 1"),
    Group(2, "group 2"),
    Group(3, "group 3"),
  ]);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          DropdownMenu(
            dropdownMenuEntries: _source.groups.map((g) => DropdownMenuEntry(value: g, label: g.name)).toList(),
            onSelected: (selected) {
              _source.clearFilters(columnName: "group");
              if (selected != null) {
                _source.addFilter(
                    "group",
                    FilterCondition(type: FilterType.equals, value: selected, filterBehavior: FilterBehavior.strongDataType, filterOperator: FilterOperator.or,)
                );
              }
            },
          )
        ],
      ),
      body: SfDataGrid(source: _source, columns: [
        GridColumn(columnName: "group", label: const Text("Group")),
        GridColumn(columnName: "other", label: const Text("Other")),
      ],

      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
