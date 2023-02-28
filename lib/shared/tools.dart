import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';

class AppManager extends ChangeNotifier {
  ThemeMode thememode = ThemeMode.light;

  get themeMode => thememode;

  toggleTheme(bool isDark) {
    thememode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  savePref(String Key,Value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = Key;
    final value = Value;
    // print(value.runtimeType.toString());
     print(prefs.getKeys());
    if (value.runtimeType.toString() == 'bool')
    {prefs.setBool(key, value);}
    else if (value.runtimeType.toString() == 'String')
    {prefs.setString(key, value);}

  }
  Future readPref(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    final key = Key;
    final value = prefs.get(key);
    // print('loaded');
    // print(prefs.getKeys());
    return value;
  }
  Future get_StockPrice() async {
    String StockName = "MSFT";
    final url = Uri.parse(
        'https://finance.yahoo.com/quote/' + StockName + '?p=' + StockName +
            '&ncid=yahooproperties_peoplealso_km0o32z3jzm');
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
    return ("Previous closing: " + titles[0] + ' ' + Currency);
  }

  Future get_GoldPrice() async {
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
    print("Last gold price : " + titles[0] + ' ' + Currency);
    List<String> StockInfo = [titles[0], Currency];
    return StockInfo;
  }

  Future get_GoldPriceDubai() async {
    final url = Uri.parse('https://www.goldpricesdubai.com/ar');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    List titles = html.querySelectorAll('td[ class="rate stable"]').map((e) =>
        e.innerHtml.trim()).toList();
    var goldprice;
    try{ goldprice= titles[0];}
    catch(Exception){try{ titles = html.querySelectorAll('td[ class="rate falling"]').map((e) =>
        e.innerHtml.trim()).toList();
    goldprice= titles[0];}
    catch(Exception){ titles = html.querySelectorAll('td[ class="rate rising"]').map((e) =>
        e.innerHtml.trim()).toList();
    goldprice= titles[0];}}
    return goldprice;
  }

  Future get_CurrencyConversion() async {

    String Initial_Currency = "USD=X";
    double Money = 100.0;
    String Final_Currency = "AED=X";
    final url = Uri.parse('https://finance.yahoo.com/quote/' + Initial_Currency + '?p=' + Initial_Currency + '&ncid=yahooproperties_peoplealso_km0o32z3jzm');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
    double Money_in_USD = Money / double.parse(titles[0]);
    print("From " + Initial_Currency.substring(0, 3) + " toUSD: " + Money_in_USD.toString() + ' USD');
    final url2 = Uri.parse('https://finance.yahoo.com/quote/' + Final_Currency + '?p=' + Final_Currency + '&ncid=yahooproperties_peoplealso_km0o32z3jzm');
    final response2 = await http.get(url2);
    dom.Document html2 = dom.Document.html(response2.body);
    final titles2 = html2.querySelectorAll("fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']").map((e) => e.innerHtml.trim()).toList();
    double Conversion_Rate = double.parse(titles2[0]);
    double Money_in_Desired_Currency = Money_in_USD * Conversion_Rate;
    print("From USD to " + Final_Currency.substring(0, 3) + " : " + Money_in_Desired_Currency.toString() + ' ' + Final_Currency.substring(0, 3));
    return Money_in_Desired_Currency;
  }
}