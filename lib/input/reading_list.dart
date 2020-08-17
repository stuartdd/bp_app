import 'dart:io';

import 'package:bp_app/input/reading.dart';

class ReadingList {
  final List<Reading> readings;
  int index = 0;

  ReadingList(this.readings);

  del() {
    if (readings[index].len() == 0) {
      reverse();
    } else {
      readings[index].del();
    }
  }

  int len() {
    return readings[index].len();
  }

  String title() {
    return readings[index].getTitle();
  }

  int val(int i) {
    return readings[i].intValue();
  }

  clear() {
    for (var r in readings) {
      r.clear();
    }
    index = 0;
  }

  add(int v) {
    if (readings[index].append(v.toString())) {
      forward();
    }
  }

  bool isInRange() {
    return readings[index].isInRange();
  }

  bool allInRange() {
    for (var prop in readings) {
      if (!prop.isInRange()) {
        return false;
      }
    }
    return true;
  }

  forward() {
    if (index < (readings.length - 1)) {
      index++;
    }
  }

  reverse() {
    if (index > 0) {
      index--;
    } else {
      index = readings.length - 1;
    }
  }

  reset() {
    index = 0;
  }

  String toString() {
    return readings[index].toString();
  }

  String testStr() {
    String s = "";
    for (int i = 0; i < readings.length; i++) {
      if (i == index) {
        s = s + "[${readings[i].toString()}]";
      } else {
        s = s + readings[i].toString();
      }
      s = s + '/';
    }
    return s.substring(0, s.length - 1);
  }
}
