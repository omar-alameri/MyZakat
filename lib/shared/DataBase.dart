import 'dart:io';
import 'package:app2/shared/tools.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app2/shared/dataModels.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Zakat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    String id = 'id INTEGER PRIMARY KEY';
    String int = 'Integer not NULL';
    String string = 'String not NULL';
    String double = 'Double not NULL';


    await db.execute('''
      CREATE TABLE Money(
          $id,
          amount $double,
          currency $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Currency(
          $id,
          initial $string,
          final $string,
          rate $double,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Gold(
          $id,
          amount $double,
          unit $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Silver(
          $id,
          amount $double,
          unit $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Livestock(
          $id,
          amount $int,
          type $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Crops(
          $id,
          amount $double,
          price $double,
          type $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Stock(
          $id,
          amount $int,
          price $double,
          stock $string,
          userEmail $String,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Language(
          $id,
          language $string,
          page $string,
          name $string,
          data $String
      )      
      ''');
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Gold', data: 'Gold').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Silver', data: 'Silver').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Livestock', data: 'Livestock').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Money', data: 'Money').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Stock', data: 'Stock').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Types', name: 'Crops', data: 'Crops').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Gold', data: 'الذهب').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Silver', data: 'الفضة').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Livestock', data: 'الأنعام').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Money', data: 'المال').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Stock', data: 'الأسهم').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Types', name: 'Crops', data: 'الزروع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Schools', name: "Shafi'i", data: "Shafi'i").toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Schools', name: 'Hanbali', data: 'Hanbali').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Schools', name: 'Maliki', data: 'Maliki').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Schools', name: 'Hanafi', data: 'Hanafi').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Schools', name: "Shafi'i", data: 'الشافعي').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Schools', name: 'Hanbali', data: 'الحنبلي').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Schools', name: 'Maliki', data: 'المالكي').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Schools', name: 'Hanafi', data: 'الحنفي').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'Language', data: 'Language').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'Language', data: 'اللغة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'School', data: 'School').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'School', data: 'المذهب').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'Currency', data: 'Currency').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'Currency', data: 'العملة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'Logout', data: 'Logout').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'Logout', data: 'تسجيل خروج').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'School', name: 'Question', data: 'Choose your School').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'School', name: 'Question', data: 'اختر مذهبك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Home', name: 'Start', data: 'Start').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Home', name: 'Start', data: 'ابدأ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Home', name: 'Info', data: 'Info').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Home', name: 'Info', data: 'معلومات').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Select', data: 'Select a type').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Select', data: 'اختر نوع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Add', data: 'Add').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Add', data: 'اضف').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Now', data: 'Calculate Now').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Now', data: 'احسب الآن').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Reminder', data: 'Set a Reminder').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Reminder', data: 'عين تذكيراً').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Calculate', data: 'Calculate Zakat').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Calculate', data: 'احسب الزكاة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Unit', data: 'Unit').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Unit', data: 'النوع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Weight', data: 'Weight (Gram)').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Weight', data: 'الوزن بالجرام').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Gram K24', data: 'Gram K24').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Gram K24', data: 'عيار 24').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Gram K22', data: 'Gram K22').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Gram K22', data: 'عيار 22').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Gram K21', data: 'Gram K21').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Gram K21', data: 'عيار 21').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'Gram K18', data: 'Gram K18').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'Gram K18', data: 'عيار 18').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Gold', name: 'No Data', data: 'No Gold in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Gold', name: 'No Data', data: 'لا توجد بيانات عن الذهب').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Unit', data: 'Unit').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Unit', data: 'النوع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Weight', data: 'Weight (Gram)').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Weight', data: 'الوزن بالجرام').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Gram K99.9', data: 'Gram K99.9').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Gram K99.9', data: 'عيار 99.9').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Gram K95.8', data: 'Gram K95.8').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Gram K95.8', data: 'عيار 95.8').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Gram K92.5', data: 'Gram K92.5').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Gram K92.5', data: 'عيار 92.5').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Gram K90', data: 'Gram K90').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Gram K90', data: 'عيار 90').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'Gram K80', data: 'Gram K80').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'Gram K80', data: 'عيار 80').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Silver', name: 'No Data', data: 'No Silver in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Silver', name: 'No Data', data: 'لا توجد بيانات عن الفضة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Money', name: 'Amount', data: 'Amount').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Money', name: 'Amount', data: 'المبلغ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Money', name: 'Currency', data: 'Currency').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Money', name: 'Currency', data: 'العملة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Money', name: 'No Data', data: 'No Money in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Money', name: 'No Data', data: 'لا توجد بيانات عن المال').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'Number', data: 'Number').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'Number', data: 'عدد').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'Type', data: 'Type').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'Type', data: 'نوع الماشية').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'Cow', data: 'Cow').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'Cow', data: 'بقر').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'Sheep', data: 'Sheep').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'Sheep', data: 'غنم').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'Camel', data: 'Camel').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'Camel', data: 'إبل').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Livestock', name: 'No Data', data: 'No Livestock in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Livestock', name: 'No Data', data: 'لا توجد بيانات عن الأنعام').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'Weight', data: 'Weight').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'Weight', data: 'الوزن بالكيلو').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'Price', data: 'Price per Kg').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'Price', data: 'السعر لكل كيلو').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'With', data: 'With cost').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'With', data: 'بتكلفة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'Without', data: 'Without cost').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'Without', data: 'دون تكلفة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'Irrigation', data: 'Irrigation').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'Irrigation', data: 'طريقة الري').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Crops', name: 'No Data', data: 'No Crops in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Crops', name: 'No Data', data: 'لا توجد بيانات عن الزروع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Stock', name: 'Name', data: 'Name').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Stock', name: 'Name', data: 'اسم السهم').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Stock', name: 'Quantity', data: 'Quantity').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Stock', name: 'Quantity', data: 'كمية').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Stock', name: 'Price', data: 'Price').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Stock', name: 'Price', data: 'السعر').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Stock', name: 'No Data', data: 'No Stock in List.').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Stock', name: 'No Data', data: 'لا توجد بيانات عن الأسهم').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'or', data: 'or').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'or', data: 'أو').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'and', data: 'and').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'and', data: 'و').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'tabea', data: 'tabea').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'tabea', data: 'تبيع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'msna', data: 'msna').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'msna', data: 'مسنة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'shah', data: 'shah').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'shah', data: 'شاه').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'bnt mkhad', data: 'bnt mkhad').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'bnt mkhad', data: 'بنت مخاض').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'bnt lboon', data: 'bnt lboon').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'bnt lboon', data: 'بنت لبون').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: 'haqqa', data: 'haqqa').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: 'haqqa', data: 'حقة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "jtha'a", data: "jtha'a").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "jtha'a", data: 'جذعة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Livestock", data: "Livestock Zakat:").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Livestock", data: 'زكاة الأنعام:').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Cow", data: "Cow").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Cow", data: 'بقر').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Sheep", data: "Sheep").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Sheep", data: 'غنم').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Camel", data: "Camel").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Camel", data: 'إبل').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Crops", data: "Crops Zakat: ").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Crops", data: 'زكاة الزروع: ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Money", data: "Money Zakat: ").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Money", data: 'زكاة المال: ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Stock", data: "Stock Zakat: ").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Stock", data: 'زكاة الأسهم: ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Gold", data: "Gold Zakat: ").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Gold", data: 'زكاة الذهب: ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "Silver", data: "Silver Zakat: ").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "Silver", data: 'زكاة الفضة: ').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CowHint1", data: "Calf that is one year old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CowHint1", data: 'البقر مااتم سنة و دخل في السنة الثانية ،ذكرا كان أو أنثى').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CowHint2", data: "Calf that is one year old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CowHint2", data: 'انثى البقر التي اتمت سنتين و دخلت في السنة الثالثه').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "SheepHint", data: "Female sheep that are one year old at least").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "SheepHint", data: 'انثى الغنم التي لا تقل عن سنة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CamelHint1", data: "Female camel that is already one year old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CamelHint1", data: 'أنثى الإبل التي أتمت سنة واحدة و دخلت في الثانية').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CamelHint2", data: "Female camel that is already two years old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CamelHint2", data: 'أنثى الإبل التي أتمت سنتان و دخلت في الثالثة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CamelHint3", data: "Female camel that is already three years old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CamelHint3", data: 'أنثى الإبل التي أتمت ثلاث سنين و دخلت في الرابعة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "CamelHint4", data: "Female camel that is already four years old").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "CamelHint4", data: 'أنثى الإبل التي أتمت أربع سنين و دخلت في الخامسة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Zakat', name: "No Zakat", data: "No Zakat is due").toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Zakat', name: "No Zakat", data: 'لا زكاة عليك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: "Shafi'i", data: "Shafi'i").toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: 'Hanbali', data: 'Hanbali').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: 'Maliki', data: 'Maliki').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: 'Hanafi', data: 'Hanafi').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: "Shafi'i", data: 'الشافعية: أن يكون'
        ' مما يقتات اختياراً: كالبر، والشعير، والأرز، والذرة، والعدس، والحمص والفول؛ والدخن، فإن لم يكن صالحاً للاقتيات: كالحلبة، والكراويا،'
        ' والكزبرة والكتان، فلا زكاة فيه؛ يكون نصاباً فأكثر؛ ولا يزكى من الثمار إلا العنب أو الرطب، فلا زكاة في الخوخ، والمشمش، والجوز، واللوز، والتين').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: 'Hanbali', data: 'الحنابلة: تجب زكاة الزروع والثمار،'
        ' بشرطين زيادة على ما تقدم: الأول: أن تكون صالحة للادخار، الثاني: أن تبلغ نصاباً وقت وجوب الزكاة.فلا فرق فيما تجب فيه الزكاة بين'
        ' كونه حباً أو غيره، مأكولاً أو غير مأكول: كالقمح، والفول، وحب الرشا، وحب الفجل، وحب الخردل، والزعتر، والأشنان وورق الشجر المقصود ...كورق السدر، والآس،'
        ' وكتمر، وزبيب، ولوز، وفستق، وبندق، أما العناب والزيتون، فلا تجب الزكاة فيهما، كما تجب في الجوز الهندي، والتين، والتوت، وبقية الفواكه وقصب السكر، '
        'واللفت، والكرنب، والبصل، والفجل، والورس، والنيلة، والحناء، والبرتقال، والقطن، والكتان، والزعفران، والعصفر، لأن هذه الأشياء لم يتحقق فيها الشرط الأول،').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: 'Maliki', data: 'المالكي').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: 'Hanafi', data: 'الحنفية:  يخرج زكاة كل ما تخرجه الأرض من الحنطة والشعير، والدخن، والأرز، وأصناف'
        ' الحبوب والبقول، والرياحين، والورد وقصب السكر، والبطيخ والقثاء، والخيار، والباذنجان، والعصفر، والتمر والعنب وغير ذلك، سواء كانت له ثمرة تبقى'
        ' أو لا، وسواء كان قليلاً أو كثيراًالحنفية:  يخرج زكاة كل ما تخرجه الأرض من الحنطة والشعير، والدخن، والأرز، وأصناف الحبوب والبقول، والرياحين'
        '، والورد وقصب السكر، والبطيخ والقثاء، والخيار، والباذنجان، والعصفر، والتمر والعنب وغير ذلك، سواء كانت له ثمرة تبقى أو لا، وسواء كان قليلاً أو كثيراً.').toMap());

  }
  Future<List<dynamic>> getData({required String userEmail,required String type}) async {
    try {
      Database db = await instance.database;
      var data = await db.query(type, where: 'userEmail = ?', whereArgs: [userEmail]);
      switch(type) {
      case 'Money' :
        return data.isNotEmpty ? data.map((c) => Money.fromMap(c)).toList() : [];
      case 'Gold':
        return data.isNotEmpty ? data.map((c) => Gold.fromMap(c)).toList() : [];
      case 'Silver':
        return data.isNotEmpty ? data.map((c) => Silver.fromMap(c)).toList() : [];
      case 'Livestock':
        return data.isNotEmpty ? data.map((c) => Livestock.fromMap(c)).toList() : [];
      case 'Crops':
        return data.isNotEmpty ? data.map((c) => Crops.fromMap(c)).toList() : [];
      case 'Stock':
        return data.isNotEmpty ? data.map((c) => Stock.fromMap(c)).toList() : [];
      default : return [];
    }
  } catch(e){
      print('error');
      return[];}
  }
  Future<List<Language>> getLanguageData ({required String language,required String page} ) async {
    Database db = await instance.database;
    // print('done');
    var data = await db.query('Language', where: 'language = ? and page = ?', whereArgs: [language,page]);
    return data.isNotEmpty ? data.map((c) => Language.fromMap(c)).toList() : [];
  }
  Future<int> addData(var data) async {
    Database db = await instance.database;
    return await db.insert(data.runtimeType.toString(), data.toMap());
  }
  Future<int> removeData(var data) async {
    Database db = await instance.database;
    return await db.delete(data.runtimeType.toString(), where: 'id = ?', whereArgs: [data.id]);
  }
  Future<int> updateData(var data) async {
    Database db = await instance.database;
    return await db.update(data.runtimeType.toString(), data.toMap(), where: 'id = ?', whereArgs: [data.id]);
  }
  Future<double> convertRate(String Initial, String Final) async {
    if (Initial==Final) return 1.0;
    double rate;
    bool reversed = false;
    Database db = await instance.database;
    // await db.rawDelete("delete from Currency where id=id");
    var data = await db.query('Currency', where: 'initial = ? AND final = ?', whereArgs: [Initial,Final],orderBy: 'date');
    if (data.isEmpty) {
      data = await db.query('Currency', where: 'initial = ? AND final = ?', whereArgs: [Final,Initial],orderBy: 'date');
      if (data.isEmpty) {
        rate = await AppManager.googleCurrencyRate(Initial, Final);
        if (rate != -1) {
          db.insert('Currency', {
            'initial': Initial,
            'final': Final,
            'rate': rate,
            'date': DateTime.now().toIso8601String()
          });
        }
        return rate;
      } else {reversed = true;
      }
    }
      DateTime d = DateTime.parse(data.last['date'] as String);
      //print(d.toString()+DateTime.now().toString());
      if(DateTime.now().minute - d.minute > 10 ) {
        print('outdated');
        rate = await AppManager.googleCurrencyRate(Initial, Final);
        if(rate !=-1) {
          db.insert('Currency', {'initial': Initial,'final':Final,'rate': rate,'date':DateTime.now().toIso8601String()});
          return rate;
        } else{
          rate = data.last['rate'] as double;
          return rate;
        }

      } else {
        // print('up to date');
        rate = data.last['rate'] as double;
        if (reversed) rate = 1.0/rate;
        return rate;
      }

  }
}