import 'package:app2/main.dart';
import 'package:app2/shared/DataBase.dart';
import 'package:app2/shared/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:flutter_localization/flutter_localization.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Map<String, String> languageData = {};
  List<String> words = ['Start','Info'];
  String language ='';
  void getData() async{
    language = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance.getLanguageData(language: language, page: 'Home');
    for (var word in words) {
      for (var e in data) {
        if (word == e.name) {
          languageData[word] = e.data;
        }
      }
    }
    setState(() {});
  }
  @override
  void initState() {

    super.initState();
    getData.call();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: language=='Arabic'? myDrawer(onDispose: (){getData.call();}):null,
      drawer: language!='Arabic' ? myDrawer(onDispose: (){getData.call();}):null,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/data');
              },
              child: Text(languageData[words[0]]??words[0]),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/info');
              },
              child: Text(languageData[words[1]]??words[1]),
            ),

          ],
        ),
      ),
    );
  }
}
