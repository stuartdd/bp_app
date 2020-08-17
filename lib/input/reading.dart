abstract class Reading {
  bool isInRange();

  append(String c);

  del();

  clear();

  int len();

  int intValue();

  String getTitle();
}

class IntReading implements Reading {
  String value = '?';
  final String title;
  final String invalid;
  final int min;
  final int max;

  IntReading(this.title, this.invalid, this.min, this.max);

  @override
  bool append(String c) {
    if (len() > 0) {
      if (len() < 3) {
        value = value + c;
      }
    } else {
      value = c;
    }
    return isInRange();
  }

  @override
  del() {
    if (len() > 0) {
      value = value.substring(0, value.length - 1);
    }
  }

  @override
  bool isInRange() {
    return ((intValue() >= min) && (intValue() <= max));
  }

  @override
  int len() {
    if ((value == null) || (value == '?') || (value.isEmpty)) {
      return 0;
    }
    return value.length;
  }

  @override
  int intValue() {
    if (len() > 0) {
      return int.parse(value);
    }
    return -1;
  }

  @override
  String toString() {
    if (len() > 0) {
      return value;
    }
    return invalid;
  }

  @override
  clear() {
    value = invalid;
  }

  @override
  String getTitle() {
    return title;
  }

}
