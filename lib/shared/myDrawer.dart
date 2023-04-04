import 'package:app2/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:provider/provider.dart';

class myDrawer extends StatefulWidget {

  const myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {

  List<String> itemsL = <String>['English', 'Arabic'];
  List<String> itemsS = <String>["Shafi'i", 'Hanbali', 'Maliki', 'Hanafi'];
  List<String> itemsC = <String>['AED', 'USD'];

  String? selectedLanguage;
  String? selectedSchool;
  String? selectedCurrency;

  @override
  void didChangeDependencies() {
    AppManager.readPref('Language').then((value)
    {selectedLanguage = value;});
    AppManager.readPref('School').then((value)
    {selectedSchool = value;});
    AppManager.readPref('pCurrency').then((value)
    {setState(() {selectedCurrency = value;});});
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
                    Switch.adaptive(
                    value: Provider.of<AppManager>(context).thememode == ThemeMode.dark,
                    onChanged: (value) {
                      AppManager.savePref('isDark', value);
                      Provider.of<AppManager>(context, listen: false).toggleTheme(Provider.of<AppManager>(context, listen: false).thememode != ThemeMode.dark);
                      setState(() {
                      });
                    }),
                    const Icon(Icons.dark_mode_outlined),

                  ],
            ),
                const Divider(),
                const Text('Language'),
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
                        AppManager.savePref('Language', selectedLanguage);
                      });
                    }),
                const Divider(),
                const Text('School'),
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
                        AppManager.savePref('School', selectedSchool);
                      });
                    }),
                const Divider(),
                const Text('Currency'),
                DropdownButton(
                    iconSize: 30,
                    iconEnabledColor: Colors.blue,
                    enableFeedback: true,
                    value: selectedCurrency,
                    items: itemsC.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (var newValue) {
                      setState(() {
                        selectedCurrency = newValue;
                        AppManager.savePref('pCurrency', selectedCurrency);

                      });
                    }),
                ElevatedButton(onPressed: (){
                  AppManager.removePref('userEmail');
                  AppManager.removePref('School');
                  AppManager.removePref('Language');
                  signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/',(route) =>false);
                }, child: const Text('SignOut'),)
              ],
        )));
  }
}
