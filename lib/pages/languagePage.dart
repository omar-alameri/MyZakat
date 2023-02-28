import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app2/shared/tools.dart';

class languagePage extends StatefulWidget {
  const languagePage({Key? key}) : super(key: key);
  @override
  State<languagePage> createState() => _languagePageState();
}

class _languagePageState extends State<languagePage> {

  String language = 'Choose a language';
@override
  void didChangeDependencies() {
    Provider.of<AppManager>(context).readPref('Language').then((value)
    {if(value!=null)Navigator.popAndPushNamed(context,'/school');});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Center(child: Text(language, style: const TextStyle(fontSize: 40),), ),
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 100,width: 150,
                    child: ElevatedButton(
                        child: const Text('English',style:  TextStyle(fontSize: 25),),
                        onPressed: () {
                          Provider.of<AppManager>(context, listen: false).savePref('Language', 'English');
                          Navigator.popAndPushNamed(context,'/school');
                      },
                        onHover: (value) =>setState(() {language = 'Choose a language';}),
                    )
                ),
                SizedBox(
                    height: 100,width: 150,
                    child: ElevatedButton(
                        child: const Text('العربية',style: TextStyle(fontSize: 25),),
                        onPressed: () {
                          Provider.of<AppManager>(context, listen: false).savePref('Language', 'Arabic');
                          Navigator.popAndPushNamed(context,'/school');                    },
                      onHover: (value) => setState(() {language = 'اختر لغة';}),

                    )
                ),
              ]),
        ]
        ),

    );
  }
}