import 'dart:async';
import 'package:app2/main.dart';
import 'package:app2/shared/MyNotification.dart';
import 'package:app2/shared/dataType.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:app2/shared/DataBase.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';

import 'InfoPage.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  dynamic school;
  bool done = false;

  List<String> items = <String>[
    'Gold',
    'Money',
    'Livestock',
    'Silver',
    'Crops',
    'Stock'
  ];
  List<String> activeItems = <String>[];
  Map<String, String> languageData = {};
  dynamic selected;
  int? selectedId;
  ScrollController scroll = ScrollController();
  String userEmail = '';
  var widgets = [];
  String language = '';

@override
  void dispose() {
     super.dispose();
     scroll.dispose();
  }
  @override
  void initState() {
    super.initState();
    getData.call();
  }

  void getData() async {
    language = await AppManager.readPref('Language');
    setState(() {});
    var LanguageData = await DatabaseHelper.instance
        .getLanguageData(language: language, page: 'Types');
    for (var item in items) {
      for (var e in LanguageData) {
        if (item == e.name) {
          languageData[item] = e.data;
        }
      }
    }
    LanguageData = await DatabaseHelper.instance
        .getLanguageData(language: language, page: 'Data');
    for (var e in LanguageData) {
      languageData[e.name] = e.data;
    }
    AppManager.readPref('pCurrency').then((value) {
      if (value == null) AppManager.savePref('pCurrency', 'AED');
    });
    userEmail = await AppManager.readPref('userEmail');
    List<dynamic> data;
    for (var item in items) {
      data = await DatabaseHelper.instance
          .getData(userEmail: userEmail, type: item);
      if (data.isNotEmpty) {
        activeItems.add(item);
      }
    }
    for (var item in activeItems) {
      items.remove(item);
    }
    school = await AppManager.readPref('School');
    if (mounted) {
      setState(() {
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: language != 'Arabic',
        title: language == 'Arabic'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_forward))
                ],
              )
            : null,
      ),
      body: done
          ? SizedBox(
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
                        if (items.isNotEmpty)
                          DropdownButton(
                              iconSize: 30,
                              iconEnabledColor: Colors.green,
                              enableFeedback: true,
                              hint: Text(
                                  languageData['Select'] ?? 'Select a type'),
                              value: selected,
                              items: items.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(languageData[item] ?? item),
                                );
                              }).toList(),
                              onChanged: (var newValue) {
                                setState(() {
                                  selected = newValue;
                                });
                              }
                              ),
                        if (items.isNotEmpty)
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
                              child: Text(languageData['Add'] ?? "Add")),
                        if (items.isNotEmpty) const VerticalDivider(),
                        PopupMenuButton(
                          position: PopupMenuPosition.over,
                          constraints: const BoxConstraints(maxWidth: 125,maxHeight: 160,minHeight: 155),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                  child: ElevatedButton(

                                  onPressed: (){
                                    Navigator.pushNamed(context, '/zakat');
                                  },
                                  child: Text(languageData['Now'] ??'Calculate Now'))),
                              
                              PopupMenuItem(
                                  child: ElevatedButton(
                                  onPressed: () async {
                                    HijriCalendar? hdate = await showHijriDatePicker(
                                        locale: localization.currentLocale,
                                        context: context,
                                        initialDate: HijriCalendar.fromDate(DateTime.now()),
                                        firstDate: HijriCalendar.fromDate(DateTime.now()),
                                        lastDate: HijriCalendar.fromDate(DateTime.now().add(const Duration(days: 365))));
                                    DateTime? date = hdate?.hijriToGregorian(hdate.hYear, hdate.hMonth, hdate.hDay);
                                    if (date!=null) {
                                      MyNotification.scheduledNotification(date: date,title: 'Zakat Reminder', body: 'Today is your zakat due date.', fln: flutterLocalNotificationsPlugin);
                                    }
                                  },
                                  child: Text(languageData['Reminder'] ??'Set a reminder'))),
                              PopupMenuItem(
                                  child: ElevatedButton(

                                      onPressed: (){
                                        Navigator.pushNamed(context, '/zakatHistory');
                                      },
                                      child: Text(languageData['History'] ??'History'))),
                            ];
                          },
                          child: ElevatedButton(

                              onPressed: null,
                              child: Row(
                                children: [
                                  Text(languageData['Calculate'] ?? "Calculate",style: const TextStyle(color: Colors.white)),
                                  const Icon(Icons.arrow_drop_down,color: Colors.white,),

                                ],
                              ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      key: Key('builder ${selectedId.toString()}'),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: activeItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ExpansionTile(
                          key: Key(selectedId.toString()),
                          maintainState: true,
                          initiallyExpanded: index == selectedId,
                          textColor: Colors.green,
                          iconColor: Colors.green,
                          title: Row(
                            children: [
                              Text(languageData[activeItems[index]] ??
                                  activeItems[index]),
                              IconButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Info(
                                          dataType: activeItems[index],
                                        )));
                              }, icon: const Icon(Icons.info_rounded))
                            ],
                          ),
                          onExpansionChanged: (value) {
                            if (value) {
                              setState(() {
                                selectedId = index;
                              });
                              Timer.periodic(const Duration(milliseconds: 500),
                                  (timer) {
                                scroll.animateTo((66.0 * index + 50),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linear);
                                timer.cancel();
                              });
                            } else {
                              setState(() {
                                selectedId = -1;
                              });
                            }
                          },
                            children: [DataType(datatype: activeItems[index])],
                        ));
                      },
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
