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
      "CREATE TABLE chord_maker(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, music_key TEXT, first_chord TEXT, later_chord TEXT, label_name TEXT, date TEXT)"
    );
  }

  static Future<void> insertData(SaveData saveData) async{
    await database.insert(
      'chord_maker',
      saveData.toMap(),
    );
  }

  static Future<List<SaveData>> getData() async{
    final List<Map<String, dynamic>> maps = await database.query('chord_maker');
    return List.generate(maps.length, (i){
      return SaveData(
        id: maps[i]['id'],
        title: maps[i]['title'],
        musicKey: maps[i]['music_key'],
        firstChord: jsonDecode(maps[i]['first_chord']),
        laterChord: jsonDecode(maps[i]['later_chord']),
        labelName: jsonDecode(maps[i]['label_name']),
        date: DateTime.parse(maps[i]['date'])
      );
    });
  }

  static Future<void> updateData(SaveData dbData, int id) async {
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