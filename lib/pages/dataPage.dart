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
  dynamic data;

  List<String> items = <String>['Gold', 'Money', 'Cattle','Silver'];
  List<String> activeItems = <String>[];
  dynamic selected;
  int? selectedId;

  @override
  void didChangeDependencies() {
    DatabaseHelper.instance.getData(1,'Money').then((value) {
       if(items.contains('Money')&&value.isNotEmpty) {
         setState(() {
        activeItems.add('Money');
        items.remove('Money');
        });
       }
    });
    DatabaseHelper.instance.getData(1,'Gold').then((value) {
      if(items.contains('Gold')&&value.isNotEmpty) {
        setState(() {
        activeItems.add('Gold');
        items.remove('Gold');
      });
      }
    });
    DatabaseHelper.instance.getData(1,'Silver').then((value) {
      if(items.contains('Silver')&&value.isNotEmpty) {
          setState(() {
          activeItems.add('Silver');
          items.remove('Silver');
        });
      }
    });
    DatabaseHelper.instance.getData(1,'Cattle').then((value) {
      if(items.contains('Cattle')&&value.isNotEmpty) {
        setState(() {
          activeItems.add('Cattle');
          items.remove('Cattle');
        });
      }
    });
    AppManager.readPref('pCurrency').then((value)
    {if(value==null)AppManager.savePref('pCurrency','USD');});

    AppManager.readPref('School').then((value)
    {setState(() {data = value;});});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(data ?? ""),
      ),
      body:SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                      onPressed: ()  {
                        // await DatabaseHelper.instance.add(
                        //   Money(amount: 10.0,currency: 'AED'),
                        // );
                        setState(() {
                          if (selected != null) {
                            activeItems.add(selected);
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
                    itemCount: activeItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ExpansionTile(
                            textColor: Colors.green,
                            iconColor: Colors.green,
                            title: Text(activeItems[index]),
                            onExpansionChanged: (value) {},
                            children: [
                              //const Divider(thickness: 1,height: 10,color: Colors.green,),
                              DataType(datatype: activeItems[index]),
                              const SizedBox(height: 10)
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
