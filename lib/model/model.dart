import 'dart:convert';

import 'package:intl/intl.dart';

class SaveData {

  int id;
  String title;
  String musicKey;
  Map<String, String> firstChord;
  Map<String, String> laterChord;
  Map<String, String> labelName;
  DateTime date;

  SaveData({this.id, this.title, this.musicKey, this.firstChord, this.laterChord, this.labelName, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['id'] = id;
    map['title'] = title;
    map['music_key'] = musicKey;
    map['first_chord'] = jsonEncode(firstChord);
    map['later_chord'] = jsonEncode(laterChord);
    map['label_name'] = jsonEncode(labelName);
    map['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    return map;
  }

}