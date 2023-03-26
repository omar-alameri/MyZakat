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

  static Future get_StockPrice(String StockName) async {
    //String StockName = "MSFT";
    final url = Uri.parse(
        'https://finance.yahoo.com/quote/$StockName?p=$StockName&ncid=yahooproperties_peoplealso_km0o32z3jzm');
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
    return ("Previous closing: ${titles[0]} $Currency");
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
    List<String> StockInfo = [titles[0], Currency];
    return StockInfo;
  }

  static Future<List<String>> get_GoldPriceDubai() async {
    final url = Uri.parse('https://www.goldpricesdubai.com/ar');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    List<String> goldprice = [];
    List titles = html.querySelectorAll('td[ class="rate falling"]').map((e) =>
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
  }

  static Future<double> get_CurrencyConversion(String initial,String finalCurrency, double money) async {

    initial = "$initial=X";
    finalCurrency = "$finalCurrency=X";
    print(initial.substring(0, 3)+finalCurrency.substring(0, 3)+money.toString());
    final url = Uri.parse('https://finance.yahoo.com/quote/$initial?p=$initial&ncid=yahooproperties_peoplealso_km0o32z3jzm');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
    double moneyInUsd = money / double.parse(titles[0]);
    print("From ${initial.substring(0, 3)} to USD : ${moneyInUsd.toString()} USD");
    final url2 = Uri.parse('https://finance.yahoo.com/quote/$finalCurrency?p=$finalCurrency&ncid=yahooproperties_peoplealso_km0o32z3jzm');
    final response2 = await http.get(url2);
    dom.Document html2 = dom.Document.html(response2.body);
    final titles2 = html2.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
    double conversionRate = double.parse(titles2[0]);
    double moneyInDesiredCurrency = moneyInUsd * conversionRate;
    print("From USD to ${finalCurrency.substring(0, 3)} : ${moneyInDesiredCurrency.toString()} ${finalCurrency.substring(0, 3)}");
    return moneyInDesiredCurrency;
  }

  static Future<double> calcTotalMoney() async {
    double total = 0.0;
    String goalCurrency = await readPref('pCurrency');
    List<dynamic> list = await DatabaseHelper.instance.getData(1,'Money');
    for (var money in list){
      total +=  await get_CurrencyConversion(money.currency,goalCurrency,money.amount);
    }
    return total;
  }
}