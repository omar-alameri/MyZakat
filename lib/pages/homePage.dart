import 'package:app2/shared/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/shared/tools.dart';
import 'package:dropdown_search/dropdown_search.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String stock = '';
  @override
  Widget build(BuildContext context) {
    Provider.of<AppManager>(context,  listen: false).get_StockPrice().then((value) {
      if (stock != value.toString())
      {stock = value.toString();setState(() {});}});
    return Scaffold(

      drawer: myDrawer(),
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){

                 Navigator.pushNamed(context, '/language');
              },
              child: const Text('Start'),
            ),
            Text(stock),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Menu mode",
                  hintText: "country in menu mode",
                ),
              ),
              onChanged: print,
              selectedItem: "Brazil",
            )

          ],
        ),
      ),
    );
  }
}
