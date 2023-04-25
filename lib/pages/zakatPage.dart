import 'package:flutter/material.dart';
import '../shared/DataBase.dart';
import '../shared/tools.dart';
import '../shared/dataModels.dart';

class ZakatPage extends StatefulWidget {
  const ZakatPage({Key? key}) : super(key: key);

  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  List<Widget> widgets =[];
  Map<String,dynamic> zakat = {};
  int loadingCounter = 0;
  bool empty = true;
  late SnackBar snackBar;
  String language = '';
  Map<String, String> languageData={};
  String userEmail = '';
  @override
  void initState() {
    AppManager.readPref('userEmail').then((value) => userEmail=value);
    super.initState();
    getData.call();
  }

  Future<Widget?> calculateMoneyZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail: userEmail,type:'Money');
    for (var money in list){
      total +=  await DatabaseHelper.instance.convertRate(money.currency,preferredCurrency)*money.amount;
    }
    String gold = await AppManager.get_GoldPriceDubai();
    if(double.tryParse(gold.substring(0,5)) != null) {
      double goldPrice = double.parse(gold.substring(0,5));
      goldPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*goldPrice;
      if (total>goldPrice*85) {
        zakat['Money'] = languageData['Money']??'Money Zakat: ${(total*0.025).toStringAsFixed(2)} $preferredCurrency';
        return Row(
              mainAxisAlignment: language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start,
              children: language=='Arabic'?[
              Text(languageData['Money']??'Money Zakat: ',textDirection:TextDirection.rtl,style: const TextStyle(decoration: TextDecoration.underline),),
          Text('${(total*0.025).toStringAsFixed(2)} $preferredCurrency',textDirection:TextDirection.rtl)
          ].reversed.toList():[
                Text(languageData['Money']??'Money Zakat: ',style: TextStyle(decoration: TextDecoration.underline),),
                Text('${(total*0.025).toStringAsFixed(2)} $preferredCurrency')
              ],
            );
      } zakat['Money'] ='';
    }
    else {
      snackBar =  const SnackBar(
          content: Text('Currencies are not updated. Gold price is not found.'),
        behavior: SnackBarBehavior.floating,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<Widget?> calculateStockZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail:userEmail,type:'Stock');
    List<String> stockPrice;
    for (var stock in list){
      stockPrice = await AppManager.get_StockPrice(stock.stock);
      total += await DatabaseHelper.instance.convertRate(stockPrice[1], preferredCurrency)*double.parse(stockPrice[0])*stock.amount;
    }
    String gold = await AppManager.get_GoldPriceDubai();
    if(double.tryParse(gold.substring(0,5)) != null) {
      double goldPrice = double.parse(gold.substring(0,5));
      goldPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*goldPrice;
      if (total>goldPrice*85) {
        zakat['Stock'] = languageData['Stock']??'Stock Zakat: ${(total*0.025).toStringAsFixed(2)} $preferredCurrency';
        return Row(
            mainAxisAlignment: language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start,
            children: language=='Arabic'?[
                Text(languageData['Stock']??'Stock Zakat: ',textDirection:TextDirection.rtl,style: const TextStyle(decoration: TextDecoration.underline),),
                Text('${(total*0.025).toStringAsFixed(2)} $preferredCurrency',textDirection:TextDirection.rtl)
              ].reversed.toList():[
                Text(languageData['Stock']??'Stock Zakat: ',style: const TextStyle(decoration: TextDecoration.underline),),
                Text('${(total*0.025).toStringAsFixed(2)} $preferredCurrency')
              ],
          );
      } zakat['Stock'] ='';
    }
    else {
      snackBar =  const SnackBar(
        content: Text('Stock data not available. Gold price is not found.'),
        behavior: SnackBarBehavior.floating,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<Widget?> calculateGoldZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail:userEmail,type:'Gold');
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
        zakat['Gold'] = languageData['Gold']??'Gold Zakat: ${(total*0.025*goldPrice).toStringAsFixed(2)} $preferredCurrency';
        return Row(
            mainAxisAlignment: language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start,
            children: language=='Arabic'?[
            Text(languageData['Gold']??'Gold Zakat: ',textDirection:TextDirection.rtl,style: const TextStyle(decoration: TextDecoration.underline),),
            Text('${(total*0.025*goldPrice).toStringAsFixed(2)} $preferredCurrency',textDirection:TextDirection.rtl)
            ].reversed.toList():[
              Text(languageData['Gold']??'Gold Zakat: ',style: const TextStyle(decoration: TextDecoration.underline),),
              Text('${(total*0.025*goldPrice).toStringAsFixed(2)} $preferredCurrency')
            ],
        );
      } zakat['Gold'] ='';
    }
    else {
      snackBar =  const SnackBar(
        content: Text('Gold price is not found.'),
        behavior: SnackBarBehavior.floating,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<Widget?> calculateSilverZakat() async {
    double total = 0.0;
    String preferredCurrency = await AppManager.readPref('pCurrency');
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail:userEmail,type:'Silver');
    for (var e in list) {
      if (e.unit == 'Gram K99.9') {
        total += e.amount;
      } else if (e.unit == 'Gram K95.8') {
        total += e.amount*0.958;
      } else if (e.unit == 'Gram K92.5') {
        total += e.amount*0.925;
      } else if (e.unit == 'Gram K90') {
        total += e.amount*0.9;
      } else if (e.unit == 'Gram K80') {
        total += e.amount*0.8;
      }
    }
    String silver = await AppManager.get_SilverPrice();
    if(double.tryParse(silver) != null) {
      double silverPrice = double.parse(silver);
      silverPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*silverPrice;
      if (total>595) {
        zakat['Silver'] = languageData['Silver']??'Silver Zakat: ${(total*0.025*silverPrice).toStringAsFixed(2)} $preferredCurrency';
        return Row(
            mainAxisAlignment: language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start,
            children: language=='Arabic'?[
            Text(languageData['Silver']??'Silver Zakat: ',textDirection:TextDirection.rtl,style: const TextStyle(decoration: TextDecoration.underline),),
            Text('${(total*0.025*silverPrice).toStringAsFixed(2)} $preferredCurrency',textDirection:TextDirection.rtl)
            ].reversed.toList():[
                Text(languageData['Silver']??'Silver Zakat: ',style: const TextStyle(decoration: TextDecoration.underline),),
                Text('${(total*0.025*silverPrice).toStringAsFixed(2)} $preferredCurrency')
            ],
          );
      } zakat['Silver'] ='';
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
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail:userEmail,type:'Crops');
    for (var e in list) {
      total += e.amount;
      if (e.type == 'With') {
        totalZakatInKg += e.amount*0.05;
        totalZakatInMoney += e.amount*e.price*0.05;
      } else if (e.type == 'Without') {
        totalZakatInKg += e.amount*0.1;
        totalZakatInMoney += e.amount*e.price*0.1;
      }

    }
    if(total>653 ) {
      zakat['Crops'] = languageData['Crops']??'Crops Zakat: ${(totalZakatInKg).toStringAsFixed(2)} Kg ${languageData['or']??'or'} ${(totalZakatInMoney).toStringAsFixed(2)} $preferredCurrency';
      return Row(
        mainAxisAlignment: language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start,
        children: language=='Arabic'?[
        Text(languageData['Crops']??'Crops Zakat: ',textDirection: TextDirection.rtl,style: const TextStyle(decoration: TextDecoration.underline),),
        Text('${(totalZakatInKg).toStringAsFixed(2)} Kg ${languageData['or']??'or'} ${(totalZakatInMoney).toStringAsFixed(2)} $preferredCurrency',textDirection: TextDirection.rtl)
        ].reversed.toList():[
          Text(languageData['Crops']??'Crops Zakat: ',style: const TextStyle(decoration: TextDecoration.underline),),
          Text('${(totalZakatInKg).toStringAsFixed(2)}Kg ${languageData['or']??'or'} ${(totalZakatInMoney).toStringAsFixed(2)}$preferredCurrency')
        ],
      );
    } zakat['Crops'] ='';


  }
  Future<Widget?> calculateLivestockZakat() async {
    // String userEmail = await AppManager.readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(
        userEmail:userEmail, type:'Livestock');
    int cow = 0;
    int camel = 0;
    int sheep = 0;
    String CowMessage1 = '';
    String CowMessage2 = '';
    String SheepMessage = '';
    String CamelMessage1 = '';
    String CamelMessage2 = '';
    String CowHint1 = languageData['CowHint1']??'Calf that is one year old. Male or Female';
    String CowHint2 = languageData['CowHint2']??'Female Calf that is already two years old';
    String sheepHint = languageData['SheepHint']??'Female sheep that are one year old at least';
    String camelHint1 = languageData['CamelHint1']??'Female camel that is already one year old';
    String camelHint2 = languageData['CamelHint2']??'Female camel that is already two years old';
    String camelHint3 = languageData['CamelHint3']??'Female camel that is already three years old';
    String camelHint4 = languageData['CamelHint4']??'Female camel that is already four years old';
    String nothing = 'Nothing.';
    List<String> Hints = [];
    String or = languageData['or']??'or';
    String and = languageData['and']??'and';
    String tbee3 = languageData['tabea']??'tabea';
    String msna = languageData['msna']??'msna';
    String shah = languageData['shah']??'shah';
    String bntMkhad = languageData['bnt mkhad']??'bnt mkhad';
    String bntLboon = languageData['bnt lboon']??'bnt lboon';
    String haqqa = languageData['haqqa']??'haqqa';
    String jth3a = languageData["jtha'a"]??"jtha'a" ;

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
      CowMessage1 = ("1 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 40 && cow <= 59) {
      CowMessage1 = ("1 $msna.");
      Hints.add(CowHint2);
    } else if (cow >= 60 && cow <= 69) {
      CowMessage1 = ("2 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 70 && cow <= 79) {
      CowMessage1 = ("1 $msna");
      Hints.add(CowHint2);
      CowMessage2 = (" $and 1 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 80 && cow <= 89) {
      CowMessage1 = ("2 $msna.");
      Hints.add(CowHint2);
    } else if (cow >= 90 && cow <= 99) {
      CowMessage1 = ("3 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 100 && cow <= 109) {
      CowMessage1 = ("1 $msna");
      Hints.add(CowHint2);
      CowMessage2 = (" $and 2 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 110 && cow <= 119) {
      CowMessage1 = ("2 $msna");
      Hints.add(CowHint2);
      CowMessage2 = (" $and 2 $tbee3.");
      Hints.add(CowHint1);
    } else if (cow >= 120 && cow <= 129) {
      CowMessage1 = ("3 $msna");
      CowMessage2 = (" $or 4 $tbee3.");
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    } else {
      int temp = cow - 120;
      int tbea = temp ~/ 30;
      int msnaN = temp ~/ 40;
      CowMessage1 = "${3 + msnaN} $msna";
      CowMessage2 = " $or ${4 + tbea} $tbee3.";
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    }
    Hints.add(sheepHint);
    if (sheep < 40) {
      SheepMessage = nothing;
      Hints.remove(sheepHint);
    } else if (sheep >= 40 && sheep <= 120) {
      SheepMessage = ("$shah.");
    } else if (sheep >= 121 && sheep <= 200) {
      SheepMessage = ("2 $shah.");
    } else if (sheep >= 201 && sheep <= 399) {
      SheepMessage = ("3 $shah.");
    } else if (sheep >= 400 && sheep <= 499) {
      SheepMessage = ("4 $shah.");
    } else if (sheep >= 500 && sheep <= 599) {
      SheepMessage = ("5 $shah.");
    } else {
      int temp = sheep - 500;
      int shahN = temp ~/ 100;
      SheepMessage = ("${5 + shahN} $shah.");
    }
    if (camel < 4) {
      CamelMessage1 = nothing;
    } else if (camel >= 5 && camel <= 9) {
      CamelMessage1 = ("1 $shah.");
    } else if (camel >= 10 && camel <= 14) {
      CamelMessage1 = ("2 $shah.");
    } else if (camel >= 15 && camel <= 19) {
      CamelMessage1 = (" 3 $shah.");
    } else if (camel >= 20 && camel <= 24) {
      CamelMessage1 = (" 4 $shah.");
    } else if (camel >= 25 && camel <= 35) {
      CamelMessage1 = ("1 $bntMkhad.");
      Hints.add(camelHint1);
    } else if (camel >= 36 && camel <= 45) {
      CamelMessage1 = ("1 $bntLboon.");
      Hints.add(camelHint2);
    } else if (camel >= 46 && camel <= 60) {
      CamelMessage1 = ("1 $haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 61 && camel <= 75) {
      CamelMessage1 = ("1 $jth3a.");
      Hints.add(camelHint4);
    } else if (camel >= 76 && camel <= 90) {
      CamelMessage1 = ("2 $bntLboon.");
      Hints.add(camelHint2);
    } else if (camel >= 91 && camel <= 120) {
      CamelMessage1 = ("2 $haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 121 && camel <= 129) {
      CamelMessage1 = ("3 $bntLboon.");
      Hints.add(camelHint2);
    } else if (camel >= 130 && camel <= 139) {
      CamelMessage1 = ("2 $bntLboon");
      CamelMessage2 = (" $and 1 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 140 && camel <= 149) {
      CamelMessage1 = ("1 $bntLboon");
      CamelMessage2 = (" $and 2 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 150 && camel <= 159) {
      CamelMessage1 = ("3 $haqqa.");
      Hints.add(camelHint3);
    } else if (camel >= 160 && camel <= 169) {
      CamelMessage1 = ("4 $bntLboon.");
      Hints.add(camelHint2);
    } else if (camel >= 170 && camel <= 179) {
      CamelMessage1 = ("3 $bntLboon");
      CamelMessage2 = (" $and 1 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 180 && camel <= 189) {
      CamelMessage1 = ("2 $bntLboon");
      CamelMessage2 = (" $and 2 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 190 && camel <= 199) {
      CamelMessage1 = ("1 $bntLboon");
      CamelMessage2 = (" $and 3 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if (camel >= 200 && camel <= 209) {
      CamelMessage1 = ("5 $bntLboon");
      CamelMessage2 = (" $or 4 $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else {
      int temp = camel - 200;
      int bntlaboon = temp ~/ 40;
      int haqqaN = temp ~/ 50;
      CamelMessage1 = ("${5 + bntlaboon} $bntLboon");
      CamelMessage2 = (" $or ${4 + haqqaN} $haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    }
    if (CowMessage1 != nothing||SheepMessage != nothing||CamelMessage1 != nothing) {
      zakat['Livestock'] = languageData['Livestock']??'Livestock Zakat:';
      if (CowMessage1 != nothing)zakat['Livestock'] += '\n\t${languageData['Cow']??'Cow'}: $CowMessage1';
      if (CowMessage2 != nothing)zakat['Livestock'] += CowMessage2;
      if (SheepMessage != nothing)zakat['Livestock'] += '\n\t${languageData['Sheep']??'Sheep'}: $SheepMessage';
      if (CamelMessage1 != nothing)zakat['Livestock'] += '\n\t${languageData['Camel']??'Camel'}: $CamelMessage1';
      if (CamelMessage2 != nothing)zakat['Livestock'] += CamelMessage2;
      return Column(
        crossAxisAlignment:language=='Arabic'?CrossAxisAlignment.end:CrossAxisAlignment.start ,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(languageData['Livestock']??'Livestock Zakat:',style: const TextStyle(decoration: TextDecoration.underline),textDirection: language=='Arabic'?TextDirection.rtl:TextDirection.ltr ,),
          Row(
              mainAxisAlignment:language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start ,
              children: language=='Arabic'?[
            if (CowMessage1 != nothing) Text('\t${languageData['Cow']??'Cow'}: ',textDirection: TextDirection.rtl),
            if (CowMessage1 != nothing) Hint(message: Hints.removeAt(0),reversed: true, child: Text(CowMessage1,textDirection: TextDirection.rtl)),
            if (CowMessage2 != '') Hint(message: Hints.removeAt(0),reversed: true, child: Text(CowMessage2,textDirection: TextDirection.rtl)),
          ].reversed.toList():[
                if (CowMessage1 != nothing) Text('\t${languageData['Cow']??'Cow'}: '),
                if (CowMessage1 != nothing) Hint(message: Hints.removeAt(0), child: Text(CowMessage1)),
                if (CowMessage2 != '') Hint(message: Hints.removeAt(0), child: Text(CowMessage2)),
              ]),
          Row(
              mainAxisAlignment:language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start ,
              children: language=='Arabic'?[
            if (SheepMessage != nothing) Text('\t${languageData['Sheep']??'Sheep'}: ',textDirection: TextDirection.rtl),
            if (SheepMessage != nothing) Hint(message: Hints.removeAt(0),reversed: true, child: Text(SheepMessage,textDirection: TextDirection.rtl),)
          ].reversed.toList():[
          if (SheepMessage != nothing) Text('\t${languageData['Sheep']??'Sheep'}: '),
          if (SheepMessage != nothing) Hint(message: Hints.removeAt(0), child: Text(SheepMessage))
          ]),
          Row(
              mainAxisAlignment:language=='Arabic'?MainAxisAlignment.end:MainAxisAlignment.start ,
              children: language=='Arabic'?[
            if (CamelMessage1 != nothing)  Text('\t${languageData['Camel']??'Camel'}: ',textDirection: TextDirection.rtl),
            if (CamelMessage1 != nothing) Hint(message: Hints.removeAt(0),reversed: true, child: Text(CamelMessage1,textDirection: TextDirection.rtl)) ,
            if (CamelMessage2 != '') Hint(message: Hints.removeAt(0),reversed: true, child: Text(CamelMessage2,textDirection: TextDirection.rtl))
          ].reversed.toList():[
            if (CamelMessage1 != nothing)  Text('\t${languageData['Camel']??'Camel'}: '),
            if (CamelMessage1 != nothing) Hint(message: Hints.removeAt(0), child: Text(CamelMessage1)) ,
            if (CamelMessage2 != '') Hint(message: Hints.removeAt(0), child: Text(CamelMessage2))
            ]),
        ],
      );
    } zakat['Livestock'] ='';
  }
  void addData(dynamic value){
  loadingCounter++;
  if(loadingCounter>=6) {
  DatabaseHelper.instance.addData(
  Zakat(Gold: zakat['Gold'], Silver: zakat['Silver'], Stock: zakat['Stock'], Crops: zakat['Crops'], Livestock: zakat['Livestock'], Money: zakat['Money'], userEmail: userEmail, date: DateTime.now()));
  }
  if(value!=null) {
  empty =false;
  widgets.add(value);
  }
  if (mounted) setState(() {});
}

  void getData() async{
    setState(() {});
    var data = await DatabaseHelper.instance.getLanguageData(language:language, page: 'Zakat');
    for (var e in data) {
      languageData[e.name]=e.data;
    }
     calculateMoneyZakat().then((value) {
       addData(value);
     });
     calculateGoldZakat().then((value) {
       addData(value);
    });
     calculateSilverZakat().then((value) {
       addData(value);
     });
     calculateLivestockZakat().then((value) {
       addData(value);
     });
     calculateCropsZakat().then((value) {
       addData(value);
     });
     calculateStockZakat().then((value){
       addData(value);
     });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: language!='Arabic',
        title: language=='Arabic' ?Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_forward))],
        ):null,
      ),
      body: SelectableRegion(
        focusNode: FocusNode(),
        selectionControls: MaterialTextSelectionControls(),
        child: !(loadingCounter>=6) ? const Center(child: CircularProgressIndicator()): empty ?  Center(child: Text(languageData['No Zakat']??"No Zakat is due"))
            :ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widgets.length,
            itemBuilder: (BuildContext context,index) {
              return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),

                  ),
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: widgets[index],
                  )
              );
            }),

        ),

    );
  }
}
