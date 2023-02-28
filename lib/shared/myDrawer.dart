import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:provider/provider.dart';

class myDrawer extends StatefulWidget {

  myDrawer();

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {

  List<String> itemsL = <String>['English', 'Arabic'];
  List<String> itemsS = <String>['الشافعي', 'الحنبلي', 'المالكي', 'الحنفي',];

  var selectedLanguage;
  var selectedSchool;

  @override
  void didChangeDependencies() {
    Provider.of<AppManager>(context).readPref('Language').then((value)
    {setState(() {selectedLanguage = value;});});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 150,
        child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.light_mode_outlined),
                    Switch(
                    value: Provider.of<AppManager>(context).thememode == ThemeMode.dark,
                    onChanged: (value) {
                      Provider.of<AppManager>(context, listen: false).savePref('isDark', value);
                      Provider.of<AppManager>(context, listen: false).toggleTheme(Provider.of<AppManager>(context, listen: false).thememode != ThemeMode.dark);
                      setState(() {
                      });
                    }),
                    const Icon(Icons.dark_mode_outlined),

                  ],
            ),
                DropdownButton(
                    iconSize: 30,
                    iconEnabledColor: Colors.blue,
                    enableFeedback: true,
                    value: selectedLanguage,
                    items: itemsL.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (var newValue) {
                      setState(() {
                        selectedLanguage = newValue;
                        Provider.of<AppManager>(context, listen: false).savePref('Language', selectedLanguage);
                      });
                    }),
                DropdownButton(
                    iconSize: 30,
                    iconEnabledColor: Colors.blue,
                    enableFeedback: true,
                    value: selectedSchool,
                    items: itemsS.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (var newValue) {
                      setState(() {
                        selectedSchool = newValue;
                        Provider.of<AppManager>(context, listen: false).savePref('School', selectedSchool);
                      });
                    }),

              ],
        )));
  }
}
