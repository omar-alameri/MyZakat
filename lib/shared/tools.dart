import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';
import 'DataBase.dart';

class AppManager extends ChangeNotifier {
  ThemeMode thememode = ThemeMode.light;

  get themeMode => thememode;

  toggleTheme(bool isDark) {
    thememode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static savePref(String key,value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value.runtimeType.toString() == 'bool')
    {prefs.setBool(key, value);}
    else if (value.runtimeType.toString() == 'String')
    {prefs.setString(key, value);}

  }

  static Future readPref(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.get(key);
  }
  static Future removePref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future get_StockPrice(String StockName) async {
    final url = Uri.parse(
        'https://finance.yahoo.com/quote/$StockName?p=$StockName');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html.querySelectorAll("td[data-test='PREV_CLOSE-value']")
          .map((e) => e.innerHtml.trim())
          .toList();

      final currency = html.querySelectorAll("div>span").map((e) =>
          e.innerHtml.trim()).toList();
      String Currency = currency[1].toString().substring(currency[1]
          .toString()
          .length - 3, currency[1]
          .toString()
          .length);
      return [titles.isEmpty ? 'no Data found':titles[0],Currency];
    } on Exception catch (e) {
      return ['No Internet connection.',''];
    }
  }

  static Future<List<List<String>>> search_StockName(String StockName) async {
    final url = Uri.parse(
        'https://finance.yahoo.com/lookup/equity?s=$StockName&t=A&b=0&c=100');
    try {

      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html.querySelectorAll('td[class="data-col0 Ta(start) Pstart(6px) Pend(15px)"] > a[class="Fw(b)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      final names = html.querySelectorAll('td[class="data-col1 Ta(start) Pstart(10px) Miw(80px)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      print(titles);
      print(names);

      return [titles.isEmpty ? ['no Data found']:titles,names];
    } on Exception catch (e) {
      return [['No Internet connection.','']];
    }
  }

  static Future<List<List<String>>> search_Currency(String Currency) async {
    final url = Uri.parse(
        'https://finance.yahoo.com/lookup/currency?s=usd$Currency&t=A&b=0&c=100');
    try {

      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html.querySelectorAll('td[class="data-col0 Ta(start) Pstart(6px) Pend(15px)"] > a[class="Fw(b)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      final names = html.querySelectorAll('td[class="data-col1 Ta(start) Pstart(10px) Miw(80px)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      print(titles);
      print(names);

      return [titles.isEmpty ? ['no Data found']:titles,names];
    } on Exception catch (e) {
      return [['No Internet connection.','']];
    }
  }

  static Future get_GoldPrice() async {
    final url = Uri.parse('https://finance.yahoo.com/quote/GC=F/');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html.querySelectorAll("td[data-test='LAST_PRICE-value']")
        .map((e) => e.innerHtml.trim())
        .toList();
    final currency = html.querySelectorAll("div>span").map((e) =>
        e.innerHtml.trim()).toList();
    String Currency = currency[1].toString().substring(currency[1]
        .toString()
        .length - 3, currency[1]
        .toString()
        .length);
    return [titles[0], Currency];
  }

  static Future<List<String>> get_GoldPriceDubai() async {
    final url = Uri.parse('https://www.goldpricesdubai.com/ar');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      List<String> goldprice = [];
      List titles = html.querySelectorAll('td[ class="rate stable"]').map((e) =>
          e.innerHtml.trim()).toList();
      if(titles.isEmpty) {
        titles = html.querySelectorAll('td[ class="rate falling"]').map((e) =>
          e.innerHtml.trim()).toList();
      }
      if(titles.isEmpty) {
        titles = html.querySelectorAll('td[ class="rate rising"]').map((e) =>
          e.innerHtml.trim()).toList();
      }
      titles.map((e) => goldprice.add(e)).toList();
      return goldprice;
    } on Exception catch (e) {
      return ['No Internet connection.','','',''];
    }

  }

  static Future<double> get_CurrencyConversion(String initial,String finalCurrency, double money) async {

    initial = "$initial=X";
    finalCurrency = "$finalCurrency=X";
    print(initial.substring(0, 3)+finalCurrency.substring(0, 3)+money.toString());
    final url = Uri.parse('https://finance.yahoo.com/quote/$initial?p=$initial');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
      double moneyInUsd = money / double.parse(titles[0]);
      print("From ${initial.substring(0, 3)} to USD : ${moneyInUsd.toString()} USD");
      final url2 = Uri.parse('https://finance.yahoo.com/quote/$finalCurrency?p=$finalCurrency');
      final response2 = await http.get(url2);
      dom.Document html2 = dom.Document.html(response2.body);
      final titles2 = html2.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
      double conversionRate = double.parse(titles2[0]);
      double moneyInDesiredCurrency = moneyInUsd * conversionRate;
      print("From USD to ${finalCurrency.substring(0, 3)} : ${moneyInDesiredCurrency.toString()} ${finalCurrency.substring(0, 3)}");
      return moneyInDesiredCurrency;
    } on Exception catch (e) {
      return -1;
    }
  }

  static Future<double> calcTotalMoney() async {
    double total = 0.0;
    String goalCurrency = await readPref('pCurrency');
    String userEmail = await readPref('userEmail');
    List<dynamic> list = await DatabaseHelper.instance.getData(userEmail,'Money');
    for (var money in list){
      total +=  await DatabaseHelper.instance.convertRate(money.currency,goalCurrency)*money.amount;
    }
    return total;
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: 10,
      excludeFromSemantics: true,
      preferBelow: true,
      showDuration: Duration(milliseconds: message.length*100),
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.all(12),
      decoration:
      // ShapeDecoration(
      //   color: Colors.grey.withOpacity(0.9),
      //   shape: ShapeOfViewBorder(shape: BubbleShape(
      //       position: BubblePosition.Top,
      //       arrowPositionPercent: 0.5,
      //       borderRadius: 20,
      //       arrowHeight: 5,
      //       arrowWidth: 5
      //   ),),
      // ),
      BoxDecoration(
          color: Colors.grey.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22)),
      textStyle: const TextStyle(fontSize: 15, color: Colors.white),
      child: Row(children: [child, const Icon(Icons.info_rounded,color: Colors.grey,size: 20)]),
    );
  }
}
