import 'dart:convert';

import 'package:path/path.dart';
import 'package:simple_resumaker/model/model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {

  static Database database;

  static Future<Database> setDb() async{
    if(database == null) {
      database = await initDb();
      return database;
    } else {
      return database;
    }
  }

  static Future<Database> initDb() async{
    String path = join(await getDatabasesPath(), 'chord_maker.db');

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  static Future<void> _createTable(Database db, int version) async{
    return await db.execute(
      "CREATE TABLE chord_maker(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, saveData TEXT, date TEXT)"
    );
  }

  static Future<void> insertData(DbData dbData) async{
    await database.insert(
      'chord_maker',
      dbData.toMap(),
    );
  }

  static Future<List<DbData>> getData() async{
    final List<Map<String, dynamic>> maps = await database.query('chord_maker');
      return List.generate(maps.length, (i){
      return DbData(
        id: maps[i]['id'],
        title: maps[i]['title'],
        saveData: jsonDecode(maps[i]['saveData']),
        date: DateTime.parse(maps[i]['date'])
      );
    });
  }

  static Future<void> updateData(DbData dbData, int id) async {
    await database.update(
    'chord_maker',
    dbData.toMap(),
    where: "id = ?",
    whereArgs: [id],
    conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteData(int id) async {
    await database.delete(
      'chord_maker',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}