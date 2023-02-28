import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/shared/tools.dart';

class DataType extends StatefulWidget {
  final String datatype;

  const DataType({required this.datatype});

  @override
  State<DataType> createState() => _DataTypeState();
}

class _DataTypeState extends State<DataType> {
  var selected;
  final List<TableRow> list = [];
  TextEditingController input = TextEditingController();
  double Total = 0.0;
  Widget holder = const CircularProgressIndicator();
  Widget Money() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
                  toolbarOptions: const ToolbarOptions(copy: true,selectAll: true,paste: true),
                  style: const TextStyle(fontSize:20),
                  controller: input,
                ),
                flex: 3),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(

                    hint: const Text('Select currency'),
                    value: selected,
                    items: [
                      const DropdownMenuItem(
                        child: Text('AED'),
                        value: 'AED',
                      ),
                      const DropdownMenuItem(
                        child: Text('USD'),
                        value: 'USD',
                      ),
                    ],
                    onChanged: (var newvalue) {
                      setState(() {
                        selected = newvalue;
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {

                    if(input.text!=''&&selected!=null)
                    list.add(TableRow(
                        children: [Text(input.text), Text(selected)]));
                    Provider.of<AppManager>(context, listen: false).get_CurrencyConversion().then((value) {
                      Total += value;
                      setState(() {});
                      });
                    selected = null;
                    input.text='';
                  });

                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        Table(
          children: list,
        ),
        const Divider(height: 20, color: Colors.blue,),
        Table(
          children: [TableRow(children: [Text('Total: '+Total.toString()), const Text('AED')])],
        )

      ],
    );
  }

  String GoldRate = '';

  Widget Gold() {

    Provider.of<AppManager>(context).get_GoldPriceDubai().then((value) {
      if (GoldRate != value.toString())
      {GoldRate = value.toString();
        holder = Text(GoldRate);
        if (mounted)setState(() {});}});
    return Column(
      children: [
        const Text(": "+"سعر الذهب"),
        holder,
      ],
    );
  }

  Widget Animals() {
    return Container(
      child: const Text('Animals'),
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.datatype) {
      case 'Money':
        return Money();
      case 'Gold':
        return Gold();
      case 'Animals':
        return Animals();
      default:
        return Container();
    }
  }
}
