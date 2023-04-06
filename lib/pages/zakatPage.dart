import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/DataBase.dart';
import '../shared/tools.dart';

class ZakatPage extends StatefulWidget {
  const ZakatPage({Key? key}) : super(key: key);

  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  List<Widget?> widgets =[];
  late SnackBar snackBar;
  bool done = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<Widget?> calculateMoneyZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail,'Money');
    for (var money in list){
      total +=  await DatabaseHelper.instance.convertRate(money.currency,preferredCurrency)*money.amount;
    }
    String gold = await AppManager.get_GoldPriceDubai();
    if(double.tryParse(gold.substring(0,5)) != null) {
      double goldPrice = double.parse(gold.substring(0,5));
      goldPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*goldPrice;
      if (total>goldPrice*85) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Money Zakat: ${(total*0.025).toStringAsFixed(2)+preferredCurrency}'),
              ],
            ),
          ],
        );
      }
    }
    else {
      snackBar =  const SnackBar(
          content: Text('Currencies are not updated. Gold price is not found.'),
        behavior: SnackBarBehavior.floating,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<Widget?> calculateGoldZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail,'Gold');
    for (var e in list) {
      if (e.unit == 'Gram K24') {
        total += e.amount;
      } else if (e.unit == 'Gram K22') {
        total += e.amount*(22/24);
      } else if (e.unit == 'Gram K21') {
        total += e.amount*(21/24);
      } else if (e.unit == 'Gram K18') {
        total += e.amount*(18/24);
      }
    }
    String goldList = await AppManager.get_GoldPriceDubai();
    if(double.tryParse(goldList.substring(0,5)) != null) {
      double goldPrice = double.parse(goldList.substring(0,5));
      goldPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*goldPrice;
      if (total>85) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gold Zakat: ${(total*0.025*goldPrice).toStringAsFixed(2)+preferredCurrency}'),
          ],
        );
      }
    }
    else {
      snackBar =  const SnackBar(
        content: Text('Gold price is not found.'),
        behavior: SnackBarBehavior.floating,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<Widget?> calculateCropsZakat() async {
    double total = 0.0;
    double totalZakatInKg = 0.0;
    double totalZakatInMoney = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail,'Crops');
    for (var e in list) {
      total += e.amount;
      if (e.type == 'With cost') {
        totalZakatInKg += e.amount*0.05;
        totalZakatInMoney += e.amount*e.price*0.05;
      } else if (e.type == 'Without cost') {
        totalZakatInKg += e.amount*0.1;
        totalZakatInMoney += e.amount*e.price*0.1;
      }

    }
    if(total>653 ) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crops Zakat: ${(totalZakatInKg).toStringAsFixed(2)}Kg or ${(totalZakatInMoney).toStringAsFixed(2)}$preferredCurrency'),
        ],
      );
    }


  }
  Future<Widget?> calculateCattleZakat() async {
    String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(
        userEmail, 'Cattle');
    int cow = 0;
    int camel = 0;
    int sheep = 0;
    String CowMessage1 = '';
    String CowMessage2 = '';
    String SheepMessage = '';
    String CamelMessage1 = '';
    String CamelMessage2 = '';
    const String CowHint1 = 'Calf that is one year old.';
    const String CowHint2 = 'Calf that is already two years old.';
    const String sheepHint = 'Female sheep that are one year old at least.';
    const String camelHint1 = 'Female camel that is already one year old.';
    const String camelHint2 = 'Female camel that is already two years old';
    const String camelHint3 = 'Female camel that is already three years old.';
    const String camelHint4 = 'Female camel that is already four years old.';
    const String nothing = 'Nothing.';
    List<String> Hints = [];


    for (var e in list) {
      if (e.type == 'Cow') {
        cow += e.amount as int;
      } else if (e.type == 'Sheep') {
        sheep += e.amount as int;
      } else if (e.type == 'Camel') {
        camel += e.amount as int;
      }
    }

    if (cow < 30) {
      CowMessage1 = nothing;
    } else if (cow >= 30 && cow <= 39) {
      CowMessage1 = ("1 tabea'.");
      Hints.add(CowHint1);
    } else if (cow >= 40 && cow <= 59) {
      CowMessage1 = ("1 msna.");
      Hints.add(CowHint2);
    } else if (cow >= 60 && cow <= 69) {
      CowMessage1 = ("2 tabea'.");
      Hints.add(CowHint1);
    } else if (cow >= 70 && cow <= 79) {
      CowMessage1 = ("1 msna");
      Hints.add(CowHint2);
      CowMessage2 = (" and 1 tbea'.");
      Hints.add(CowHint1);
    } else if (cow >= 80 && cow <= 89) {
      CowMessage1 = ("2 msna.");
      Hints.add(CowHint2);
    } else if (cow >= 90 && cow <= 99) {
      CowMessage1 = ("3 tbea'.");
      Hints.add(CowHint1);
    } else if (cow >= 100 && cow <= 109) {
      CowMessage1 = ("1 msna");
      Hints.add(CowHint2);
      CowMessage2 = (" and 2 tbea'.");
      Hints.add(CowHint1);
    } else if (cow >= 110 && cow <= 119) {
      CowMessage1 = ("2 msna");
      Hints.add(CowHint2);
      CowMessage2 = (" and 2 tbea'.");
      Hints.add(CowHint1);
    } else if (cow >= 120 && cow <= 129) {
      CowMessage1 = ("3 msna");
      CowMessage2 = (" or 4 tbea'.");
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    } else {
      int temp = cow - 120;
      int tbea = temp ~/ 30;
      int msna = temp ~/ 40;
      CowMessage1 = "${3 + msna} msna";
      CowMessage2 = " or ${4 + tbea} tbea'.";
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    }
    Hints.add(sheepHint);
    if (sheep < 40) {
      SheepMessage = nothing;
      Hints.remove(sheepHint);
    } else if (sheep >= 40 && sheep <= 120) {
      SheepMessage = ("shah.");
    } else if (sheep >= 121 && sheep <= 200) {
      SheepMessage = ("2 shah.");
    } else if (sheep >= 201 && sheep <= 399) {
      SheepMessage = ("3 shah.");
    } else if (sheep >= 400 && sheep <= 499) {
      SheepMessage = ("4 shah.");
    } else if (sheep >= 500 && sheep <= 599) {
      SheepMessage = ("5 shah.");
    } else {
      int temp = sheep - 500;
      int shah = temp ~/ 100;
      SheepMessage = ("${5 + shah} shah.");
    }
    if (camel < 4) {
      CamelMessage1 = nothing;
    } else if (camel >= 5 && camel <= 9) {
      CamelMessage1 = ("1 shah.");
    } else if (camel >= 10 && camel <= 14) {
      CamelMessage1 = ("2 shah.");
    } else if (camel >= 15 && camel <= 19) {
      CamelMessage1 = (" 3 shah.");
    } else if (camel >= 20 && camel <= 24) {
      CamelMessage1 = (" 4 shah.");
    } else if (camel >= 25 && camel <= 35) {
      CamelMessage1 = ("1 bnt mkhad.");
      Hints.add(camelHint1);
    } else if (camel >= 36 && camel <= 45) {
      CamelMessage1 = ("1 bnt lboon.");
      Hints.add(camelHint2);
    } else if (camel >= 46 && camel <= 60) {
      CamelMessage1 = ("1 haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 61 && camel <= 75) {
      CamelMessage1 = ("1 jtha'a.");
      Hints.add(camelHint4);
    } else if (camel >= 76 && camel <= 90) {
      CamelMessage1 = ("2 bnt lboon.");
      Hints.add(camelHint2);
    } else if (camel >= 91 && camel <= 120) {
      CamelMessage1 = ("2 haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 121 && camel <= 129) {
      CamelMessage1 = ("3 bnt lboon.");
      Hints.add(camelHint2);
    } else if (camel >= 130 && camel <= 139) {
      CamelMessage1 = ("2 bnt lboon");
      CamelMessage2 = (" and 1 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 140 && camel <= 149) {
      CamelMessage1 = ("1 bnt lboon");
      CamelMessage2 = (" and 2 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 150 && camel <= 159) {
      CamelMessage1 = ("3 haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 160 && camel <= 169) {
      CamelMessage1 = ("4 bnt lboon.");
      Hints.add(camelHint2);
    } else if (camel >= 170 && camel <= 179) {
      CamelMessage1 = ("3 bnt lboon");
      CamelMessage2 = (" and 1 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 180 && camel <= 189) {
      CamelMessage1 = ("2 bnt lboon");
      CamelMessage2 = (" and 2 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 190 && camel <= 199) {
      CamelMessage1 = ("1 bnt lboon");
      CamelMessage2 = (" and 3 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 200 && camel <= 209) {
      CamelMessage1 = ("5 bnt lboon");
      CamelMessage2 = (" or 4 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else {
      int temp = camel - 200;
      int bntlaboon = temp ~/ 40;
      int haqqa = temp ~/ 50;
      CamelMessage1 = ("${5 + bntlaboon} bnt lboon");
      CamelMessage2 = (" or ${4 + haqqa} haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    }
    if (CowMessage1 != nothing||SheepMessage != nothing||CamelMessage1 != nothing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Cattle Zakat:'),
          Row(children: [
            if (CowMessage1 != nothing)const Text('\tCow: '),
            if (CowMessage1 != nothing) Info(message: Hints.removeAt(0), child: Text(CowMessage1)),
            if (CowMessage2 != '') Info(message: Hints.removeAt(0), child: Text(CowMessage2)),
          ]),
          Row(children: [
            if (SheepMessage != nothing)const Text('\tSheep: '),
            if (SheepMessage != nothing) Info(message: Hints.removeAt(0), child: Text(SheepMessage))
          ]),
          Row(children: [
            if (CamelMessage1 != nothing) const Text('\tCamel: '),
            if (CamelMessage1 != nothing) Info(message: Hints.removeAt(0), child: Text(CamelMessage1)) ,
            if (CamelMessage2 != '') Info(message: Hints.removeAt(0), child: Text(CamelMessage2))
          ]),
        ],
      );
    }
  }
  void getData() async{
    widgets.add(await calculateMoneyZakat());
    widgets.add(await calculateCattleZakat());
    widgets.add(await calculateCropsZakat());
    widgets.add(await calculateGoldZakat());
    if (mounted) {
      setState(() {done=true;});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakat'),
      ),

      body: SelectableRegion(
        focusNode: FocusNode(),
        selectionControls: MaterialTextSelectionControls(),
        child: Center(
          child: done ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widgets.length,
            itemBuilder: (BuildContext context,index) {
              if(widgets[index]!=null) {
                return Card(
                elevation: 10,
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: widgets[index],
                )
                );
              }
            }):const CircularProgressIndicator(),
        ),
      )

    );
  }
}
