import 'package:app2/shared/dataType.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:app2/shared/DataBase.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  dynamic school;

  List<String> items = <String>[
    'Gold',
    'Money',
    'Cattle',
    'Silver',
    'Crops',
    'Stock'
  ];
  List<String> activeItems = <String>[];
  dynamic selected;
  int? selectedId;
  ScrollController scroll = ScrollController();

  @override
  void didChangeDependencies() {
    for (String s in items) {
      DatabaseHelper.instance.getData(1, s).then((value) {
        if (items.contains(s) && value.isNotEmpty) {
          setState(() {
            activeItems.add(s);
            items.remove(s);
          });
        }
      });
    }
    AppManager.readPref('pCurrency').then((value) {
      if (value == null) AppManager.savePref('pCurrency', 'USD');
    });

    AppManager.readPref('School').then((value) {
      setState(() {
        school = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(school ?? ""),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                      iconSize: 30,
                      iconEnabledColor: Colors.green,
                      enableFeedback: true,
                      hint: const Text('Select a type'),
                      disabledHint: const Text('All types are displayed'),
                      value: selected,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (var newValue) {
                        setState(() {
                          selected = newValue;
                        });
                      }),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (selected != null) {
                            activeItems.add(selected);
                            items.remove(selected);
                            selected = null;
                          }
                        });
                      },
                      child: const Text("Add")),
                ],
              ),
              ListView.builder(
                primary: true,
                key: Key('builder ${selectedId.toString()}'), //attention
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: activeItems.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ExpansionTile(
                    key: Key(index.toString()),
                    initiallyExpanded: index == selectedId,
                    textColor: Colors.green,
                    iconColor: Colors.green,
                    title: Text(activeItems[index]),
                    onExpansionChanged: (value) {
                      if (value) {
                        setState(() {
                          selectedId = index;
                        });
                        scroll.animateTo((66.0 * index + 50),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear);
                      } else {
                        setState(() {
                          selectedId = -1;
                        });

                      }
                    },
                    children: [
                      DataType(datatype: activeItems[index]),
                    ],
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
