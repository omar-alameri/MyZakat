import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/shared/tools.dart';

class schoolPage extends StatefulWidget {
  const schoolPage({Key? key}) : super(key: key);

  @override
  State<schoolPage> createState() => _schoolPageState();
}

class _schoolPageState extends State<schoolPage> {
  var data;

  String language = 'English';
  Map<String, String> map = {
    'Arabic': 'اختر مذهبك',
    'English': 'Choose your School',
    'Arabic1': 'الشافعي',
    'English1': "Shafi'i",
    'Arabic2': 'الحنبلي',
    'English2': 'Hanbali',
    'Arabic3': 'المالكي',
    'English3': 'Maliki',
    'Arabic4': 'الحنفي',
    'English4': 'Hanafi'
  };
  next(String s){
    Provider.of<AppManager>(context, listen: false).savePref('School', s);
    Navigator.popAndPushNamed(context,'/data');
  }
  @override
  void didChangeDependencies() {
    Provider.of<AppManager>(context, listen: false).readPref('School').then((value)
    {if(value!=null)Navigator.popAndPushNamed(context,'/data');});
    Provider.of<AppManager>(context).readPref('Language').then((value)
         {setState(() {data = value;});});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    if (map[data] == null)
      language = map['English']!;
    else
      language = map[data]!;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
              child: Text(
            language,
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
                      map[(data ?? 'English') + '1']!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(map[data + '1']!),
                  )),
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      map[(data ?? 'English') + '2']!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(map[data + '2']!),
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
                      map[(data ?? 'English') + '3']!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(map[data['language'] + '3']!),
                  )),
              SizedBox(
                  height: 100,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      map[(data ?? 'English') + '4']!,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => next(map[data['language'] + '4']!),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
