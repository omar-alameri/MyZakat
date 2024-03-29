import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/LoginPage.dart';
import '../pages/SignUpPage.dart';
import 'FireStoreFunctions.dart';

class AppManager extends ChangeNotifier {
  ThemeMode thememode = ThemeMode.light;

  get themeMode => thememode;

  toggleTheme(bool isDark) {
    thememode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  static savePref(String key, value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value.runtimeType.toString() == 'bool') {
      prefs.setBool(key, value);
    } else if (value.runtimeType.toString() == 'String') {
      prefs.setString(key, value);
    }
  }

  static Future readPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future removePref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<List<String>> getStockPrice(String StockName) async {
    final url =
        Uri.parse('https://finance.yahoo.com/quote/$StockName?p=$StockName');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll("td[data-test='PREV_CLOSE-value']")
          .map((e) => e.innerHtml.trim())
          .toList();

      final currency = html
          .querySelectorAll("div>span")
          .map((e) => e.innerHtml.trim())
          .toList();
      String Currency = currency[1].toString().substring(
          currency[1].toString().length - 3, currency[1].toString().length);
      return [titles.isEmpty ? 'no Data found' : titles[0], Currency];
    } on Exception {
      return ['No Internet connection.', ''];
    }
  }

  static Future<List<List<String>>> searchStockName(String StockName) async {
    final url = Uri.parse(
        'https://finance.yahoo.com/lookup/equity?s=$StockName&t=A&b=0&c=100');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll(
              'td[class="data-col0 Ta(start) Pstart(6px) Pend(15px)"] > a[class="Fw(b)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      final names = html
          .querySelectorAll(
              'td[class="data-col1 Ta(start) Pstart(10px) Miw(80px)"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      print(titles);
      print(names);

      return [
        titles.isEmpty ? ['no Data found'] : titles,
        names
      ];
    } on Exception {
      return [
        ['No Internet connection.']
      ];
    }
  }

  static Future<List<String>> searchCurrency(String Currency) async {
    final url = Uri.parse(
        'https://finance.yahoo.com/lookup/currency?s=usd$Currency&t=A&b=0&c=100');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll(
              'td[class="data-col0 Ta(start) Pstart(6px) Pend(15px)"] > a[class="Fw(b)"]')
          .map((e) => e.innerHtml.trim().substring(0, 3))
          .toList();
      return titles.isEmpty ? ['no Data found'] : titles;
    } on Exception {
      return ['No Internet connection.'];
    }
  }

  static Future getGoldPrice() async {
    final url = Uri.parse('https://finance.yahoo.com/quote/GC=F/');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll("td[data-test='LAST_PRICE-value']")
        .map((e) => e.innerHtml.trim())
        .toList();
    final currency = html
        .querySelectorAll("div>span")
        .map((e) => e.innerHtml.trim())
        .toList();
    String Currency = currency[1].toString().substring(
        currency[1].toString().length - 3, currency[1].toString().length);
    return [titles[0], Currency];
  }

  static Future<String> getGoldPriceDubai() async {
    final url = Uri.parse('https://www.goldpricesdubai.com');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      String? goldPrice =
          html.querySelector('td[ class="rate stable"]')?.innerHtml;
      goldPrice ??= html.querySelector('td[ class="rate falling"]')?.innerHtml;
      goldPrice ??= html.querySelector('td[ class="rate rising"]')?.innerHtml;
      return goldPrice ?? 'NoData';
    } on Exception {
      return 'No Internet connection.';
    }
  }

  static Future<String> getSilverPrice() async {
    final url =
        Uri.parse('https://www.worldforexrates.com/xag/aed/1-exchange-rate/');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll(
              "div[class='widget custom'] > table > tbody > tr > td")
          .map((e) => e.innerHtml.trim())
          .toList();
      return titles[2];
    } on Exception {
      return 'No Internet connection.';
    }
  }

  static Future delete_User(String Email) async {
    DeleteAccountTimer.cancel();
    VerifyTimer.cancel();
    await get_User_Document_Id(Email);
    Delete_User_Info(Email);
    await FirebaseAuth.instance.currentUser?.delete();
    await signOut();
    //print("Email verification link has expired. Please sign up again");
  }

  static Future<double> getCurrencyConversion(
      String initial, String finalCurrency, double money) async {
    initial = "$initial=X";
    finalCurrency = "$finalCurrency=X";
    final url =
        Uri.parse('https://finance.yahoo.com/quote/$initial?p=$initial');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll(
              "fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']")
          .map((e) => e.innerHtml.trim())
          .toList();
      double moneyInUsd = money / double.parse(titles[0]);
      // print("From ${initial.substring(0, 3)} to USD : ${moneyInUsd.toString()} USD");
      final url2 = Uri.parse(
          'https://finance.yahoo.com/quote/$finalCurrency?p=$finalCurrency');
      final response2 = await http.get(url2);
      dom.Document html2 = dom.Document.html(response2.body);
      final titles2 = html2
          .querySelectorAll(
              "fin-streamer[class='Fw(b) Fz(36px) Mb(-4px) D(ib)']")
          .map((e) => e.innerHtml.trim())
          .toList();
      double conversionRate = double.parse(titles2[0]);
      double moneyInDesiredCurrency = moneyInUsd * conversionRate;
      return moneyInDesiredCurrency;
    } on Exception {
      return -1;
    }
  }

  static Future<double> getCurrencyRateGoogle(
      String initial, String finalCurrency) async {
    final url = Uri.parse(
        'https://www.google.com/finance/quote/$initial-$finalCurrency');
    try {
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final titles = html
          .querySelectorAll('div[class="YMlKec fxKbKc"]')
          .map((e) => e.innerHtml.trim())
          .toList();
      return double.parse(titles[0]);
    } on Exception {
      return -1;
    }
  }
}

class Hint extends StatelessWidget {
  const Hint({
    super.key,
    required this.message,
    required this.child,
    this.reversed = false,
  });

  final String message;
  final Widget child;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: 10,
      excludeFromSemantics: true,
      preferBelow: true,
      showDuration: Duration(milliseconds: message.length * 100),
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22)),
      textStyle: const TextStyle(fontSize: 15, color: Colors.white),
      child: Row(
          children: reversed
              ? [
                  child,
                  const Icon(Icons.info_rounded, color: Colors.grey, size: 20)
                ].reversed.toList()
              : [
                  child,
                  const Icon(Icons.info_rounded, color: Colors.grey, size: 20)
                ]),
    );
  }
}

class CountDown extends StatefulWidget {
  final int time;

  const CountDown({Key? key, required this.time}) : super(key: key);

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late int timerCount;

  late Timer t;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerCount = widget.time;
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount == 0) timer.cancel();
      if (mounted) {
        setState(() {
          timerCount--;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t.cancel();
  }

  Widget build(BuildContext context) {
    return Text(timerCount.toString());
  }
}
