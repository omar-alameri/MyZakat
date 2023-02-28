import 'package:app2/shared/DataType.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/shared/tools.dart';

class dataPage extends StatefulWidget {
  const dataPage({Key? key}) : super(key: key);

  @override
  State<dataPage> createState() => _dataPageState();
}

class _dataPageState extends State<dataPage> {
  var data;

  List<String> items = <String>['Gold', 'Money', 'Animals'];
  List<String> activeitems = <String>[];
  var selected;
  @override
  void didChangeDependencies() {
    Provider.of<AppManager>(context, listen: false).readPref('School').then((value)
    {setState(() {data = value;});});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(data ?? ""),
      ),
      body:SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                      iconSize: 30,
                      iconEnabledColor: Colors.blue,
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
                    onPressed: () {
                      setState(() {
                        if (selected != null) {
                          activeitems.add(selected);
                          items.remove(selected);
                          selected = null;
                        }
                      });
                    },
                    child: const Text("Add")
                  ),
                ],
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activeitems.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ExpansionTile(
                      title: Text(activeitems[index]),
                      onExpansionChanged: (value) {},
                      children: [
                        const Divider(thickness: 1,height: 1,color: Colors.blue,),
                        DataType(datatype: activeitems[index]),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                items.add(activeitems[index]);
                                activeitems.remove(activeitems[index]);
                              });
                            },
                            child: const Text('Remove')),
                      ],
                    ));
                  },
                ),

            ],
          ),
      ),

    );
  }
}
