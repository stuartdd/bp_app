import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const J_DATA = "data";
const J_ID = "i";
const J_SYS = "s";
const J_DIA = "d";
const J_PULSE = "p";
const J_HIDE = "h";
const J_NAME = "name";
const J_SHOW_PULSE = "showPulse";
const J_DNH = "doNotHide";

const UNKNOWN = "unknown";
const O_READINGS = "bpReadings";
const FN_PREF = "bp_log";
const FN_TYPE = "json";

class EntryWithId extends Comparable {
  final DateFormat monthFormat = DateFormat("MMM");
  DateTime _dateTime;
  bool hidden = false;

  EntryWithId(this._dateTime, this.hidden);

  String pad(int i) {
    if (i < 10) {
      return "0" + i.toString();
    }
    return i.toString();
  }

  bool isPM() {
    return _dateTime.hour > 12;
  }

  String dateTimeString() {
    return dateString() + " " + timeString();
  }

  String dateTimeShort() {
    return "${monthFormat.format(_dateTime)} ${pad(_dateTime.day)} - ${pad(_dateTime.hour)}:${pad(_dateTime.minute)}";
  }

  String dateString() {
    return "${monthFormat.format(_dateTime)} ${pad(_dateTime.day)} ${_dateTime.year}";
  }

  String timeString() {
    return "${pad(_dateTime.hour)}:${pad(_dateTime.minute)}:${pad(_dateTime.second)}";
  }

  int getId() {
    return _dateTime.millisecondsSinceEpoch;
  }

  String toJson() {
    return "\"$J_ID\":${getId()},\"$J_HIDE\":${hidden ? '1' : '0'}";
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

  BPEntry(DateTime dt, this.systolic, this.diastolic, this.pulse, bool hidden) : super(dt, hidden);

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

  int min() {
    return math.min(math.min(systolic, diastolic), pulse);
  }

  int max() {
    return math.max(math.max(systolic, diastolic), pulse);
  }

  String values() {
    return " ${padded(systolic)}/${padded(diastolic)}|${padded(pulse)}";
  }

  String toJson() {
    return '{' + super.toJson() + ",\"$J_SYS\":" + systolic.toString() + ",\"$J_DIA\":" + diastolic.toString() + ",\"$J_PULSE\":" + pulse.toString() + '}';
  }
}

class SettingsData {
  static String userName = UNKNOWN;
  static bool doNotHide = false;
  static bool showPulseInGraphs = true;
  static List<EntryWithId> _list = [];

  static add(EntryWithId value) {
    _list.insert(0, value);
  }

  static List<EntryWithId> cloneList() {
    _list.sort();
    List<EntryWithId> tmp = [];
    for (var ent in _list) {
      if (!ent.hidden || doNotHide) {
        tmp.add(ent);
      }
    }
    return tmp;
  }

  static List<EntryWithId> cloneListAMPM(bool pm, int maxCount) {
    _list.sort();
    List<EntryWithId> tmp = [];
    for (var ent in _list) {
      if ((!ent.hidden || doNotHide) && (ent.isPM() == pm)) {
        tmp.add(ent);
        if (tmp.length >= maxCount) {
          break;
        }
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
      s = s + ',';
    }
    return '{\"$J_NAME\":\"$userName\",\"$J_SHOW_PULSE\":$showPulseInGraphs,\"$J_DNH\":$doNotHide,  \"$J_DATA\":[' + s.substring(0, mark) + ']}';
  }

  static String tryParse(String json) {
    String existing = toJson();
    _list.clear();
    try {
      parseJson(json);
      return "OK";
    } on Exception catch (e) {
      parseJson(existing);
      return e.toString();
    }
  }

  static int readInt(Map map, String name) {
    int val = map[name];
    return val == -1 ? false : val;
  }

  static DateTime readId(Map map, String name, int count) {
    int val = map[name];
    return val == null ? DateTime.now().add(Duration(minutes: count)) : DateTime.fromMillisecondsSinceEpoch(val);
  }

  static bool readBool(Map map, String name) {
    bool val = map[name];
    return val == null ? false : val;
  }

  static bool readBoolInt(Map map, String name) {
    int val = map[name];
    if (val == null) {
      return false;
    }
    return val == 0 ? false : true;
  }

  static parseJson(String json) {
    Map userMap = jsonDecode(json);
    if (userMap[J_NAME] == null) {
      userMap[J_NAME] = UNKNOWN;
    }
    if (userMap[J_NAME] != null) {
      userName = userMap[J_NAME];
    } else {
      userName = UNKNOWN;
    }

    if (userMap[J_SHOW_PULSE] != null) {
      showPulseInGraphs = userMap[J_SHOW_PULSE];
    } else {
      showPulseInGraphs = false;
    }

    if (userMap[J_DNH] != null) {
      doNotHide = userMap[J_DNH];
    } else {
      doNotHide = false;
    }

    int count = 0;
    if (userMap[O_READINGS] == null) {
      for (var input in userMap[J_DATA]) {
        count++;
        var ent = BPEntry(readId(input, J_ID, count), readInt(input, J_SYS), readInt(input, J_DIA), readInt(input, J_PULSE), readBoolInt(input, J_HIDE));
        SettingsData.add(ent);
      }
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
