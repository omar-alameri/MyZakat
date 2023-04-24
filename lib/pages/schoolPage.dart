import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';

import '../shared/DataBase.dart';

class schoolPage extends StatefulWidget {
  const schoolPage({Key? key}) : super(key: key);

  @override
  State<schoolPage> createState() => _schoolPageState();
}

class _schoolPageState extends State<schoolPage> {
  String selectedLanguage = 'English';
  List<String> Schools = <String>["Shafi'i", 'Hanbali', 'Maliki', 'Hanafi'];
  Map<String, String> languageData = {};
  next(String s){
    AppManager.savePref('School', s);
    Navigator.popAndPushNamed(context,'/home');
  }

  void getData() async {
    AppManager.readPref('School').then((value)
    {if(value!=null)Navigator.popAndPushNamed(context,'/home');});
    selectedLanguage = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance
        .getLanguageData(language: selectedLanguage, page: 'Schools');
    for (var school in Schools) {
      for (var e in data) {
        if (school == e.name) {
          languageData[school] = e.data;
        }
      }
    }
    data = await DatabaseHelper.instance
        .getLanguageData(language: selectedLanguage, page: 'School');
    languageData['Question'] = data.first.data;
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
              child: Text(
                languageData['Question']??'Choose your School',
            style: const TextStyle(
              fontSize: 40,
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      languageData[Schools[0]]??Schools[0],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(Schools[0]),
                  )),
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      languageData[Schools[1]]??Schools[1],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(Schools[1]),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      languageData[Schools[2]]??Schools[2],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(Schools[2]),
                  )),
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      languageData[Schools[3]]??Schools[3],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(Schools[3]),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
