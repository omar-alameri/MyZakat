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
      CREATE TABLE Zakat(
          $id,
          Gold $double,
          Silver $double,
          Stock $double,
          Livestock $String,
          Money $double,
          Crops $double,
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
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'Download', data: 'Download Data').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'Download', data: 'حمل بياناتك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'General', name: 'Upload', data: 'Upload Data').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'General', name: 'Upload', data: 'ارفع بياناتك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'School', name: 'Question', data: 'Choose your School').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'School', name: 'Question', data: 'اختر مذهبك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Home', name: 'Start', data: 'Calculate Your Zakat').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Home', name: 'Start', data: 'احسب زكاتك').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Home', name: 'Info', data: 'Info about zakat').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Home', name: 'Info', data: 'معلومات عن الزكاة').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Select', data: 'Select a type').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Select', data: 'اختر نوع').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Add', data: 'Add').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Add', data: 'اضف').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Now', data: 'Calculate Now').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Now', data: 'احسب الآن').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Reminder', data: 'Set a Reminder').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Reminder', data: 'عين تذكيراً').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'History', data: 'History').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'History', data: 'سجل').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Data', name: 'Calculate', data: 'Zakat').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Data', name: 'Calculate', data: 'الزكاة').toMap());
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
    await db.insert('Language',const Language(language: 'English', page: 'MoneyInfo', name: 'All', data: '''- Nisab : the price of 85 grams of gold.
The zakat is 2.5% of what one owns, for ease of calculation it is the amount of money devised by 40.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'MoneyInfo', name: 'All', data: '''نصاب المال 85 غرام من الذهب * سعر الذهب.
و زكاته %2.5 من المال ; اي مقدار المال مقسوم على .40''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'GoldInfo', name: 'All', data: '''- Nisab : 85 grams of gold.
The zakat is 2.5% of what one owns of gold(or its equivalent in money).''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'GoldInfo', name: 'All', data: '''نصاب الذهب 85 غرام.
و زكاته %2.5 من الذهب (أو ما يساويه من المال).''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'SilverInfo', name: 'All', data: '''- Nisab : 595 grams of silver. 
The zakat is 2.5% of what one owns of silver (or its equivalent in money).''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'SilverInfo', name: 'All', data: '''نصاب الفضة 595 غرام.
و زكاته %2.5 من الفضة (أو ما يساويه من المال).''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'LivestockInfo', name: 'All', data: '''There is no particular Nisab , but one hand over based on how much he owns as
shown in the below table( or its equivalent in money).
It must be noted that only grazing livestock most of the year are required for zakat, meaning the ones that eat from the earth and are not paid to eat.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'LivestockInfo', name: 'All', data: '''الزكاة فقط في السائمة; اي التي ترعى، و شرط انها رعت اكثر العام (الزكاة قد تكون بما يساويها من المال). ''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'LivestockInfo', name: 'Maliki', data: '''There is no particular Nisab , but one hand over based on how much he owns as shown in the below table( or its equivalent in money). 
It must be noted that both grazing and non -grazing livestock are required for Zakat.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'LivestockInfo', name: 'Maliki', data: '''الزكاة في السائمة; اي التي ترعى، و شرط انها رعت اكثر العام، و المعلوفة; اي التي ينفق عليها صاحبها و لا ترعى (الزكاة قد تكون بما يساويها من المال). ''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: 'All', data: '''- Nisab: 654 kg. 
The zakat is 10% of what one owns if it was watered by rain, and 5% if it was watered by irrigation.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: 'All', data: '''نصابه 5 اوسق، اي 654 كغ.
و زكاته %10 اذا سقيت بالطر و %5 اذا سقيت بالري.''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'CropsInfo', name: 'Hanafi', data: '''- Nisab: There is no Nisab. 
The zakat is 10% of what one owns if it was watered by rain, and 5% if it was watered by irrigation.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'CropsInfo', name: 'Hanafi', data: '''لا نصاب.
و زكاته %10 اذا سقيت بالطر و %5 اذا سقيت بالري.''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'StockInfo', name: 'All', data: '''- Nisab: There is no Nisab. 
The zakat is 2.5% of the price of his shares, if he trades in them, i.e. buying and selling.
But if he is saving it for a profit such as rent, then the zakat is 2.5% of the profits.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'StockInfo', name: 'All', data: '''زكاته %2.5 من سعر اسهمه، اذا كان يتاجر فيها اي للبيع و الشراء.
أما إذا كان يدخرها من أجل الأرباح كالإيجار فالزكاة %2.5 من الأرباح.''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'Info', name: 'Debt', data: 'Debt').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'Info', name: 'Debt', data: 'الديون').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'DebtInfo', name: 'Maliki', data: '''The debt you owe is added with the zakat of money.
Here the debt is categorized into two, hard or easy to regain. If it is easy to regain then:
One only pay the zakat of what is indebted to him for one year when he regains it.
If the money is hard to regain then:
One only pay the zakat of what is indebted to him for one year when he regains it.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'DebtInfo', name: 'Maliki', data: '''يضاف الذي تدين به مع زكاة المال.
الدين المرجو أدائه; أي يستطيع المديون سده أو يسهل استرداده:
يزكي عند القبض لسنة واحدة.
الدين الغير الرجو ادائه; أي لا يستطيع المديون سده أو يصعب استرداده:
يزكيه عند القبض، لسنة واحدة.''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'DebtInfo', name: "Shafi'i", data: '''The debt you owe is added with the zakat of money.
Here the debt is categorized into two, hard or easy to regain. If it is easy to regain then:
One must add what is indebted to him to the money he owns every year even if one have yet to regain it, and calculate zakat accordingly.
If the money is hard to regain then:
One must pay the Zakat of what is indebted to him when he regains it for all the years that he did not have it.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'DebtInfo', name: "Shafi'i", data: '''يضاف الذي تدين به مع زكاة المال.
الدين المرجو أدائه; أي يستطيع المديون سده أو يسهل استرداده:
يزكي مع ماله كل حول.
الدين الغير الرجو ادائه; أي لا يستطيع المديون سده أو يصعب استرداده:
يزكيه عند القبض، لكل السني التي مضت. و هكذا للدين الؤجل.''').toMap());
    await db.insert('Language',const Language(language: 'English', page: 'DebtInfo', name: "All", data: '''The debt you owe is added with the zakat of money.
Here the debt is categorized into two, hard or easy to regain. If it is easy to regain then:
One must add what is indebted to him to the money he owns and pay its zakat every passing year, but it is not necessary to pay before he one gets his money back, in that case he should pay for all the years that have passed.
If the money is hard to regain then:
One should not include it in one’s Zakat.''').toMap());
    await db.insert('Language',const Language(language: 'Arabic', page: 'DebtInfo', name: "All", data: '''يضاف الذي تدين به مع زكاة المال.
الدين المرجو أدائه; أي يستطيع المديون سده أو يسهل استرداده:
له زكاه كل حول، ولكن لا يجب الزكاة فيه حتى يقبص الدين (يحصل عليه)، عندها الزكاة لكل السنين التي مضت.
الدين الغير الرجو ادائه; أي لا يستطيع المديون سده أو يصعب استرداده:
لا زكاة فيه. و هكذا للدين المؤجل.''').toMap());

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
      case 'Zakat':
        return data.isNotEmpty ? data.map((c) => Zakat.fromMap(c)).toList() : [];
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
    try {
      return await db.insert(data.runtimeType.toString(), data.toMap());
    } on Exception {
      return -1;
    }
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
        rate = await AppManager.getCurrencyRateGoogle(Initial, Final);
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
        rate = await AppManager.getCurrencyRateGoogle(Initial, Final);
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