import 'dart:ui';

import 'package:flutter/material.dart';

class TitleStyle extends TextStyle {
  const TitleStyle()
      : super(
          fontSize: 30.0,
          color: Colors.black,
        );
}

class HeadingDataStyle extends TextStyle {
  const HeadingDataStyle()
      : super(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        );
}

class WarnTextStyle extends TextStyle {
  const WarnTextStyle()
      : super(
          fontSize: 15.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
}

class InputButtonStyle extends TextStyle {
  const InputButtonStyle(double size, Color c)
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
  const BlackDivider()
      : super(
          thickness: 2,
          height: 30,
          color: Colors.black,
        );
}

class ClearDivider extends Divider {
  const ClearDivider()
      : super(
          height: 30,
        );
}
