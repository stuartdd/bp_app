import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const ID = "id";
const HIDDEN = "hide";
const SYS = "sys";
const DIA = "dia";
const PULSE = "pulse";
const UNKNOWN = "unknown";
const NAME = "name";
const READINGS = "bpReadings";
const FN_PREF = "bp_log";
const FN_TYPE = "json";

const SET_NAME = "name";
const SET_DONT_HIDE = "dontHide";

class EntryWithId extends Comparable {
  final DateFormat monthFormat = DateFormat("MMM");
  DateTime _dateTime;
  bool hidden = false;

  EntryWithId(this._dateTime);

  String pad(int i) {
    if (i < 10) {
      return "0"+i.toString();
    }
    return i.toString();
  }

  bool isPM() {
    return _dateTime.hour > 12;
  }

  String dateTimeString() {
    return dateString() + " " + timeString();
  }

  String dateString() {
    return "${monthFormat.format(_dateTime)} ${pad(_dateTime.day)}  ${_dateTime.year}";
  }

  String timeString() {
    return "${pad(_dateTime.hour)}:${pad(_dateTime.minute)}:${pad(_dateTime.second)}";
  }

  int getId() {
    return _dateTime.millisecondsSinceEpoch;
  }

  String toJson() {
    return "\"$ID\": ${getId()}, \"$HIDDEN\": $hidden";
  }

  DateTime getDate() {
    return _dateTime;
  }

  setDate(DateTime tim) {
    var t = DateTime(tim.year, tim.month, tim.day, _dateTime.hour, _dateTime.minute, _dateTime.second);
    return _dateTime = t;
  }

  setTime(TimeOfDay tim) {
    var t = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, tim.hour, tim.minute, 0);
    return _dateTime = t;
  }

  @override
  int compareTo(other) {
    return ((other as EntryWithId).getId().compareTo(getId()));
  }

}

class BPEntry extends EntryWithId {
  final int systolic;
  final int diastolic;
  final int pulse;

  BPEntry(DateTime dt, this.systolic, this.diastolic, this.pulse) : super(dt);

  String padded(int v) {
    if (v < 0) {
      return '?  ';
    }
    if (v < 10) {
      return "  $v";
    }
    if (v < 100) {
      return " $v";
    }
    return v.toString();
  }

  String values() {
    return " ${padded(systolic)}/${padded(diastolic)}|${padded(pulse)}";
  }

  String toJson() {
    return '{' + super.toJson() + ", \"$SYS\": " + systolic.toString() + ", \"$DIA\": " + diastolic.toString() + ", \"$PULSE\": " + pulse.toString() + '}';
  }

}

class EntryList {
  static Map _settings = {};
  static List<EntryWithId> _list = [];
  static bool _dontHide = false;

  static String getName() {
    if (_settings[SET_NAME] == null) {
      _settings[SET_NAME] = UNKNOWN;
    }
    return _settings[SET_NAME];
  }

  static setName(String name) {
    _settings[SET_NAME] = name;
  }

  static bool getDontHide() {
    if (_settings[SET_DONT_HIDE] == null) {
      _settings[SET_DONT_HIDE] = false;
    }
    return _settings[SET_DONT_HIDE];
  }

  static setDontHide(bool dh) {
    return _settings[SET_DONT_HIDE] = dh;
  }

  static add(EntryWithId value) {
    _list.insert(0, value);
  }

  static List<EntryWithId> getList() {
    _list.sort();
    List<EntryWithId> tmp = [];
    for (var ent in _list) {
      if (!ent.hidden || getDontHide()) {
        tmp.add(ent);
      }
    }
    return tmp;
  }

  static EntryWithId getEntry(int id) {
    for (var eid in _list) {
      if (eid.getId() == id) {
        return eid;
      }
    }
    return null;
  }

  static String toJson() {
    int mark = 0;
    String s = '';
    for (var eid in _list) {
      s = s + eid.toJson();
      mark = s.length;
      s = s + ', ';
    }
    return '{ \"$NAME\": \"${getName()}\", \"$READINGS\": [' + s.substring(0, mark) + ']}';
  }

  static String tryParse(String json) {
    String existing = toJson();
    print(existing);
    _list.clear();
    try {
      parseJson(json);
      return "OK";
    } on Exception catch (e) {
      parseJson(existing);
      return e.toString();
    }
  }

  static parseJson(String json) {
    Map userMap = jsonDecode(json);
    if (userMap[NAME] == null) {
      userMap[NAME] = UNKNOWN;
    }
    _settings[SET_NAME] = userMap[NAME];
    int count = 0;
    for (var input in userMap[READINGS]) {
      count++;
      if (input[ID] == null) {
        input[ID] = DateTime.now().add(Duration(minutes: count)).millisecondsSinceEpoch;
      }
      if (input[SYS] == null) {
        input[SYS] = -1;
      }
      if (input[DIA] == null) {
        input[DIA] = -1;
      }
      if (input[PULSE] == null) {
        input[PULSE] = -1;
      }
      var ent = BPEntry(DateTime.fromMillisecondsSinceEpoch(input[ID]), input[SYS], input[DIA], input[PULSE]);
      if (input[HIDDEN] == null) {
        ent.hidden = false;
      } else {
        ent.hidden = input[HIDDEN];
      }
      EntryList.add(ent);
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(bool backup) async {
    final path = await _localPath;
    if (backup) {
      return File('$path/${FN_PREF}_bak.$FN_TYPE');
    }
    return File('$path/$FN_PREF.$FN_TYPE');
  }

  static void save(bool backup) async {
    final file = await _localFile(backup);
    file.writeAsString(toJson());
  }

  static Future<String> copyFileToClipboard(bool backup) async {
    try {
      final file = await _localFile(backup);
      String contents = await file.readAsString();
      Clipboard.setData(ClipboardData(text: contents));
      return contents;
    } on Exception catch (e) {
      Clipboard.setData(ClipboardData(text: "Unable to read file!"));
      return "Unable to read ${backup ? "BACKUP" : ""} file!";
    }
  }

  static Future<void> load(bool backup) async {
    try {
      final file = await _localFile(backup);
      String contents = await file.readAsString();
      _list.clear();
      parseJson(contents);
    } on Exception catch (e) {
      print(e);
    }
  }
}
