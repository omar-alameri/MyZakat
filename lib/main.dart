import 'package:app2/firebase_options.dart';
import 'package:app2/pages/LoginPage.dart';
import 'package:app2/pages/SignUpPage.dart';
import 'package:app2/pages/dataPage.dart';
import 'package:app2/pages/zakatPage.dart';
import 'package:flutter/material.dart';
import 'package:app2/pages/languagePage.dart';
import 'package:app2/pages/schoolPage.dart';
import 'package:app2/pages/homePage.dart';
import 'package:app2/shared/tools.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20,color: Colors.black87,fontWeight: FontWeight.w400),
          titleMedium: TextStyle(fontSize: 20,color: Colors.black),
          titleLarge: TextStyle(fontSize: 25,color: Colors.black),
        ),
        snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.grey
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.green,),
          constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(color: Colors.green)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(color: Colors.grey)
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        ),
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
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20,color: Colors.white54,fontWeight: FontWeight.w400),
          titleMedium: TextStyle(fontSize: 20,color: Colors.white),
        ),
        snackBarTheme:  const SnackBarThemeData(
          backgroundColor: Colors.grey,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.green,),
          constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(color: Colors.green)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              borderSide: BorderSide(color: Colors.grey)
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        ),
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
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const homePage(),
        '/language': (context) => const LanguagePage(),
        '/school': (context) => const schoolPage(),
        '/data': (context) => const DataPage(),
        '/zakat': (context) => const ZakatPage(),
      },
    );
  }
}


