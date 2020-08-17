// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bp_app/input/reading.dart';
import 'package:bp_app/input/reading_list.dart';
import 'package:flutter_test/flutter_test.dart';


void tm(ReadingList r, String toStr, String str, bool set, bool inRange, int len, int val) {
  expect(r.testStr(), equals(toStr));
  expect(r.toString(), equals(str));
  expect(r.len(), len);
  expect(r.val(r.index), val);
  if (!set) {
    expect(r.toString(), '?');
  }
}

void main() {
  test("Test BPReading default values", () {
    ReadingList reading = ReadingList([IntReading("Systolic", '?', 40, 200), IntReading("Diastolic", '?', 40, 300)]);
    tm(reading, "[?]/?", '?', false, false, 0, -1);
    reading.forward();
    tm(reading, "?/[?]", '?', false, false, 0, -1);
    reading.reverse();
    tm(reading, "[?]/?", '?', false, false, 0, -1);
  });

  test("Test BPReading add values", () {
    ReadingList reading = ReadingList([IntReading("Systolic", '?', 40, 200), IntReading("Diastolic", '?', 40, 300)]);
    tm(reading, "[?]/?", '?', false, false, 0, -1);
    expect(reading.allInRange(), false);
    reading.add(1);
    tm(reading, "[1]/?", '1', true, false, 1, 1);
    reading.forward();
    tm(reading, "1/[?]", '?', false, false, 0,-1);
    reading.add(9);
    tm(reading, "1/[9]", '9', true, false, 1, 9);
    reading.reverse();
    tm(reading, "[1]/9", '1', true, false, 1, 1);
    reading.add(2);
    tm(reading, "[12]/9", '12', true, false, 2, 12);
    reading.forward();
    reading.add(2);
    tm(reading, "12/[92]", '92', true, true, 2, 92);
    //
    // Check auto advance
    //
    reading.reset();
    tm(reading, "[12]/92", '12', true, false, 2, 12);
    reading.add(3);
    tm(reading, "123/[92]", '92', true, true, 2, 92);
    reading.reverse();
    tm(reading, "[123]/92", '123', true, true, 3, 123);
    reading.add(9);
    tm(reading, "123/[92]", '92', true, true, 2, 92);
    reading.reset();
    tm(reading, "[123]/92", '123', true, true, 3, 123);
  });

  test("Test BPReading add series", () {
    ReadingList reading = ReadingList([IntReading("Systolic", '?', 40, 200), IntReading("Diastolic", '?', 40, 300)]);
    reading.add(1);
    expect(reading.testStr(), equals("[1]/?"));
    reading.add(2);
    expect(reading.testStr(), equals("[12]/?"));
    expect(reading.allInRange(), false);
    reading.add(8);
    expect(reading.testStr(), equals("128/[?]"));
    expect(reading.allInRange(), false);
    reading.add(2);
    expect(reading.testStr(), equals("128/[2]"));
    reading.add(4);
    expect(reading.testStr(), equals("128/[24]"));
    expect(reading.allInRange(), false);
    reading.add(6);
    expect(reading.testStr(), equals("128/[246]"));
    reading.add(7);
    expect(reading.testStr(), equals("128/[246]"));
    expect(reading.allInRange(), true);

    reading.del();
    expect(reading.testStr(), equals("128/[24]"));
    reading.del();
    expect(reading.testStr(), equals("128/[2]"));
    reading.del();
    expect(reading.testStr(), equals("128/[?]"));
    reading.del();
    expect(reading.testStr(), equals("[128]/?"));
    reading.del();
    expect(reading.testStr(), equals("[12]/?"));
    reading.del();
    expect(reading.testStr(), equals("[1]/?"));
    reading.del();
    expect(reading.testStr(), equals("[?]/?"));
    reading.del();
    expect(reading.testStr(), equals("?/[?]"));
    reading.del();
    expect(reading.testStr(), equals("[?]/?"));
  });

}
