import 'dart:ui';

import 'package:flutter/material.dart';

class TitleStyle extends TextStyle {
  TitleStyle()
      : super(
          fontSize: 30.0,
          color: Colors.black,
        );
}

class ListDataStyle extends TextStyle {
  ListDataStyle()
      : super(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFeatures: [
            FontFeature.proportionalFigures(),
          ],
          color: Colors.green,
        );
}

class HeadingDataStyle extends TextStyle {
  HeadingDataStyle()
      : super(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        );
}

class CardHeadStyle extends TextStyle {
  CardHeadStyle(Color c)
      : super(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: c,
        );
}

class CardDescStyle extends TextStyle {
  CardDescStyle(Color c)
      : super(
          fontSize: 15.0,
          color: c,
        );
}

class WarnTextStyle extends TextStyle {
  WarnTextStyle()
      : super(
          fontSize: 15.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
}

class ButtonStyle extends TextStyle {
  ButtonStyle(double size, Color c)
      : super(
          fontSize: size,
          color: c,
          fontWeight: FontWeight.bold,
        );
}

final RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0));

RoundedRectangleBorder ButtonShape() {
  return _buttonShape;
}

class BlackDivider extends Divider {
  BlackDivider()
      : super(
          thickness: 2,
          height: 30,
          color: Colors.black,
        );
}

class ClearDivider extends Divider {
  ClearDivider()
      : super(
          height: 30,
        );
}
