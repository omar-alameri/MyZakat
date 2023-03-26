import 'package:app2/pages/dataPage.dart';
import 'package:flutter/material.dart';
import 'package:app2/pages/languagePage.dart';
import 'package:app2/pages/schoolPage.dart';
import 'package:app2/pages/homePage.dart';
import 'package:app2/shared/tools.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 runApp(
  ChangeNotifierProvider(
      create: (_) => AppManager(),
      child: const Myapp(),
  )
);
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});
  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {

  @override
  void initState() {
    AppManager.readPref('isDark').then((value) {
       if(value!=null) {
         Provider.of<AppManager>(context, listen: false).toggleTheme(value);
       }
     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
          )
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.green.shade900),
            )
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.green.shade900
        ),
        brightness: Brightness.dark,
      ),
      themeMode: Provider.of<AppManager>(context).thememode,
      //initialRoute: '/language',
      routes: {
        '/': (context) => const homePage(),
        '/language': (context) => const LanguagePage(),
        '/school': (context) => const schoolPage(),
        '/data': (context) => const DataPage(),
      },
    );
  }
}


