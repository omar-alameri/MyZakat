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
          userId $int,
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
          userId $int,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Silver(
          $id,
          amount $double,
          unit $string,
          userId $int,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Cattle(
          $id,
          amount $int,
          type $string,
          userId $int,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Crops(
          $id,
          amount $double,
          price $double,
          type $string,
          userId $int,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Stock(
          $id,
          amount $int,
          price $double,
          stock $string,
          userId $int,
          date Date
      )      
      ''');
  }
  Future<List<dynamic>> getData(int userId,String type) async {
    Database db = await instance.database;
    try {
      var data = await db.query(type, where: 'userId = ?', whereArgs: [userId]);
    switch(type) {
      case 'Money' :
        return data.isNotEmpty ? data.map((c) => Money.fromMap(c)).toList() : [];
      case 'Gold':
        return data.isNotEmpty ? data.map((c) => Gold.fromMap(c)).toList() : [];
      case 'Silver':
        return data.isNotEmpty ? data.map((c) => Silver.fromMap(c)).toList() : [];
      case 'Cattle':
        return data.isNotEmpty ? data.map((c) => Cattle.fromMap(c)).toList() : [];
      case 'Crops':
        return data.isNotEmpty ? data.map((c) => Crops.fromMap(c)).toList() : [];
      case 'Stock':
        return data.isNotEmpty ? data.map((c) => Stock.fromMap(c)).toList() : [];
      default : return [];
    }
  } catch(e){return[];}
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
         // print('nodata');
        rate = await AppManager.get_CurrencyConversion(Initial, Final, 1);
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
      if(DateTime.now().minute - d.minute > 2 ) {
        print('outdated');
        rate = await AppManager.get_CurrencyConversion(Initial, Final, 1);
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