import 'package:app2/shared/DataBase.dart';
import 'package:flutter/material.dart';
import '../shared/tools.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<String> items = <String>[
    'Gold',
    'Money',
    'Livestock',
    'Silver',
    'Crops',
    'Stock',
    'Debt'
  ];
  Map<String, String> languageData = {};
  String language = '';
  @override
  void initState() {
    super.initState();
    getData.call();
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
      body: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: language == 'Arabic'
                ? const Icon(
                    Icons.navigate_next,
                    textDirection: TextDirection.rtl,
                  )
                : Text(languageData[items[index]] ?? ''),
            trailing: language == 'Arabic'
                ? Text(languageData[items[index]] ?? '')
                : const Icon(Icons.navigate_next),
            selectedColor: Colors.green,
            minVerticalPadding: 20,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Info(
                            dataType: items[index],
                          )));
            },
          );
        },
      ),
    );
  }

  void getData() async {
    language = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance
        .getLanguageData(language: language, page: 'Types');
    for (var page in items) {
      for (var e in data) {
        if (page == e.name) {
          languageData[page] = e.data;
        }
      }
    }
    data= await DatabaseHelper.instance
        .getLanguageData(language: language, page: 'Info');
      for (var e in data) {
          languageData[e.name] = e.data;
      }


    setState(() {});
  }
}

class Info extends StatefulWidget {
  final String dataType;
  const Info({Key? key, required this.dataType}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String language = '';
  Map<String, String> languageData = {};
  String School = '';
  @override
  void initState() {
    super.initState();
    getData.call();
  }

  void getData() async {
    language = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance
        .getLanguageData(language: language, page: '${widget.dataType}Info');
    for (var e in data) {
      languageData[e.name] = e.data;
    }
    School = await AppManager.readPref('School');
    setState(() {});
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text.rich(TextSpan(text: languageData[School] ?? languageData['All'] ?? 'No Data'),
            textDirection:
                language == 'Arabic' ? TextDirection.rtl : TextDirection.ltr),
      ),
    );
  }
}
