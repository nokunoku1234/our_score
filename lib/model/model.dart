import 'dart:convert';

import 'package:intl/intl.dart';

class SaveData {

  int barNumber;
  String firstChord;
  String laterChord;
  String labelName;

  SaveData({this.barNumber, this.firstChord, this.laterChord, this.labelName});

}

class DbData {

  int id;
  String title;
  List<SaveData> saveData;
  DateTime date;

  DbData({this.id, this.title, this.saveData, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['id'] = id;
    map['title'] = title;
    map['saveData'] = jsonEncode(saveData);
    map['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

  }

}