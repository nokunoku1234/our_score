import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaveData {

  int id;
  String title;
  String musicKey;
  int barNumber;
  Map<String, dynamic> firstChord;
  Map<String, dynamic> laterChord;
  Map<String, dynamic> labelName;
  DateTime date;

  SaveData({this.id, this.title, this.musicKey, this.barNumber, this.firstChord, this.laterChord, this.labelName, this.date});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['id'] = id;
    map['title'] = title;
    map['music_key'] = musicKey;
    map['bar_number'] = barNumber;
    map['first_chord'] = jsonEncode(firstChord);
    map['later_chord'] = jsonEncode(laterChord);
    map['label_name'] = jsonEncode(labelName);
    map['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    return map;
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}