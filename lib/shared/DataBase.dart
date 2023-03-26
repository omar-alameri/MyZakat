import 'dart:io';
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
    await db.execute('''
      CREATE TABLE Money(
          id INTEGER PRIMARY KEY,
          amount Double not NULL,
          currency String not NULL,
          userId Integer not NULL,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Gold(
          id INTEGER PRIMARY KEY,
          amount Double not NULL,
          unit String not NULL,
          userId Integer not NULL,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Silver(
          id INTEGER PRIMARY KEY,
          amount Double not NULL,
          unit String not NULL,
          userId Integer not NULL,
          date Date
      )      
      ''');
    await db.execute('''
      CREATE TABLE Cattle(
          id INTEGER PRIMARY KEY,
          amount Integer not NULL,
          type String not NULL,
          userId Integer not NULL,
          date Date
      )      
      ''');
  }
  Future<List<dynamic>> getData(int userId,String type) async {
    Database db = await instance.database;
    var data = await db.query(type,where: 'userId = ?',whereArgs: [userId]);
    switch(type) {
      case 'Money' :
        return data.isNotEmpty ? data.map((c) => Money.fromMap(c)).toList() : [];
      case 'Gold':
        return data.isNotEmpty ? data.map((c) => Gold.fromMap(c)).toList() : [];
      case 'Silver':
        return data.isNotEmpty ? data.map((c) => Silver.fromMap(c)).toList() : [];
      case 'Cattle':
        return data.isNotEmpty ? data.map((c) => Cattle.fromMap(c)).toList() : [];
      default : return [];
    }
  }
  Future<int> addData(var data) async {
    Database db = await instance.database;
    return await db.insert(data.runtimeType.toString(), data.toMap());
  }
  Future<int> removeData(var data) async {
    Database db = await instance.database;
    return await db.delete(data.runtimeType.toString(), where: 'id = ?', whereArgs: [data.id]);
  }

}