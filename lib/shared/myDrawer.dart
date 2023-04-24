import 'package:app2/main.dart';
import 'package:app2/pages/LoginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'DataBase.dart';

class myDrawer extends StatefulWidget {
  final Function() onDispose;
  const myDrawer({super.key, required this.onDispose});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  List<String> itemsL = <String>['English', 'Arabic'];
  List<String> itemsS = <String>["Shafi'i", 'Hanbali', 'Maliki', 'Hanafi'];
  List<DropdownMenuItem> schoolDropDown = [];
  List<String> words = ['Language', 'School', 'Currency', 'Logout'];
  Map<String, String> languageData = {};

  String selectedLanguage = 'English';
  String? selectedSchool;
  TextEditingController selectedCurrency = TextEditingController();
  @override
  void dispose() {
    selectedCurrency.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData.call();
  }

  void getData() async {
    AppManager.readPref('School').then((value) {
      selectedSchool = value;
    });
    AppManager.readPref('pCurrency').then((value) async {
      if (value == null) {
        await AppManager.savePref('pCurrency', 'AED');
        value = 'AED';
      }
      setState(() {
        selectedCurrency.text = value;
      });
    });
    selectedLanguage = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance
        .getLanguageData(language: selectedLanguage, page: 'General');
    for (var word in words) {
      for (var e in data) {
        if (word == e.name) {
          languageData[word] = e.data;
        }
      }
    }
    data = await DatabaseHelper.instance
        .getLanguageData(language: selectedLanguage, page: 'Schools');
    for (var school in itemsS) {
      for (var e in data) {
        if (school == e.name) {
          languageData[school] = e.data;
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
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
                    value: Provider.of<AppManager>(context).thememode ==
                        ThemeMode.dark,
                    onChanged: (value) {
                      AppManager.savePref('isDark', value);
                      Provider.of<AppManager>(context, listen: false)
                          .toggleTheme(
                              Provider.of<AppManager>(context, listen: false)
                                      .thememode !=
                                  ThemeMode.dark);
                      setState(() {});
                    }),
                const Icon(Icons.dark_mode_outlined),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Text(
              languageData['Language'] ?? 'Language',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton(
                underline: const Text(''),
                iconSize: 30,
                enableFeedback: true,
                value: selectedLanguage,
                items: itemsL.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLanguage = newValue ?? '';
                    AppManager.savePref('Language', selectedLanguage);
                    getData.call();
                    if (selectedLanguage=='Arabic') {
                      localization.translate('ar');
                    } else {
                      localization.translate('en');
                    }
                    widget.onDispose.call();
                  });
                  Provider.of<AppManager>(context, listen: false).notify.call();
                }),
            const Divider(
              thickness: 1,
            ),
            Text(
              languageData['School'] ?? 'School',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton(
                underline: const Text(''),
                iconSize: 30,
                enableFeedback: true,
                value: selectedSchool,
                items: [
                  DropdownMenuItem(
                    value: itemsS[0],
                    child: Text(languageData[itemsS[0]] ?? itemsS[0]),
                  ),
                  DropdownMenuItem(
                    value: itemsS[1],
                    child: Text(languageData[itemsS[1]] ?? itemsS[1]),
                  ),
                  DropdownMenuItem(
                    value: itemsS[2],
                    child: Text(languageData[itemsS[2]] ?? itemsS[2]),
                  ),
                  DropdownMenuItem(
                    value: itemsS[3],
                    child: Text(languageData[itemsS[3]] ?? itemsS[3]),
                  ),
                ],
                onChanged: (var newValue) {
                  setState(() {
                    selectedSchool = newValue;
                    AppManager.savePref('School', selectedSchool);
                  });
                }),
            const Divider(
              thickness: 1,
            ),
            Text(
              languageData['Currency'] ?? 'Currency',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownSearch<String>(
              onBeforePopupOpening: (x) async {
                if (selectedCurrency.text == '') {
                  return false;
                } else {
                  return true;
                }
              },
              asyncItems: (x) async {
                var s = await AppManager.search_Currency(selectedCurrency.text);
                return s;
              },
              onChanged: (s) {
                AppManager.savePref('pCurrency', s);
                setState(() {
                  selectedCurrency.text = s ?? '';
                });
              },
              dropdownBuilder: (context, s) {
                return TextField(
                  onSubmitted: (s) async {
                    List<String> list = await AppManager.search_Currency(s);
                    if (!list.contains(s)) {
                      var snackBar = const SnackBar(
                        content: Center(child: Text('Invalid Currency')),
                        behavior: SnackBarBehavior.floating,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      AppManager.savePref('pCurrency', s);
                    }
                  },
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: 20, minHeight: 20),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    // contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    isCollapsed: true,
                  ),
                  controller: selectedCurrency,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.length < 4) {
                        return TextEditingValue(
                            text: newValue.text.toUpperCase(),
                            selection: newValue.selection);
                      }
                      return oldValue;
                    })
                  ],
                );
              },
              selectedItem: selectedCurrency.text,
              dropdownButtonProps: const DropdownButtonProps(
                  icon: Icon(Icons.search),
                  padding: EdgeInsets.symmetric(vertical: 4)),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                baseStyle: TextStyle(fontSize: 20),
                dropdownSearchDecoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    AppManager.removePref('userEmail');
                    signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: Text(languageData['Logout'] ?? 'Log out'),
                ),
              ),
            )
          ],
        )));
  }
}
