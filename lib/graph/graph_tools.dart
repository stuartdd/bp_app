
import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';

double deriveWidth(BuildContext context) {
  double screen = MediaQuery.of(context).size.width;
  double req = EntryList.cloneList().length.toDouble() * 50.0;
  if (req > screen) {
    return req;
  }
  return screen;
}

const double TXT_SIZE = 19;
TextPainter tp(String text, Size size, bool bold, Color c) {
  final textSpan = TextSpan(
    text: text,
    style: TextStyle(
      color: c,
      fontSize: TXT_SIZE,
      fontWeight: bold?FontWeight.bold:FontWeight.normal,
    ),
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(
    minWidth: 0,
    maxWidth: size.width,
  );
  return textPainter;
}
