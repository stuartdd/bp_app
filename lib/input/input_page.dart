import 'package:bp_app/data/list_entry.dart';
import 'package:bp_app/styles.dart';
import 'package:flutter/material.dart';

import 'reading.dart';
import 'reading_list.dart';

class InputPage extends StatefulWidget {
  ReadingList value = ReadingList([IntReading("Systolic", '?', 40, 200), IntReading("Diastolic", '?', 40, 200), IntReading("Pulse", '?', 40, 200)]);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final double okButtonSize = 45;

  final double numberSize = 60.0;
  final double valueSize = 45.0;
  final Color numberColour = Colors.green;
  final Color backgroundColour = Colors.blue[100];

  final Color focusColourFg = Colors.black;
  final Color focusColourBg = Colors.green;
  final Color errorFocusColourFg = Colors.black;
  final Color errorFocusColourBg = Colors.pink;

  final Color nonFocusColourFg = Colors.black;
  final Color nonFocusColourBg = Colors.lightGreen[200];
  final Color errorNonFocusColourFg = Colors.black54;
  final Color errorNonFocusColourBg = Colors.pink[50];

  bool doneButtonEnabled = false;
  Color doneButtonColour = Colors.green;

  FlatButton button(int val) {
    return FlatButton(
      child: new Text(
        val.toString(),
        style: InputButtonStyle(numberSize, numberColour),
      ),
      onPressed: () {
        setState(() {
          widget.value.add(val);
        });
      },
      color: backgroundColour,
      shape: ButtonShape(),
    );
  }

  FlatButton valueButton(int index) {
    var val = widget.value.readings[index];

    var fg;
    var bg;
    if (val.isInRange()) {
      if (widget.value.index == index) {
        fg = focusColourFg;
        bg = focusColourBg;
      } else {
        fg = nonFocusColourFg;
        bg = nonFocusColourBg;
      }
    } else {
      if (widget.value.index == index) {
        fg = errorFocusColourFg;
        bg = errorFocusColourBg;
      } else {
        fg = errorNonFocusColourFg;
        bg = errorNonFocusColourBg;
      }
    }
    return FlatButton(
      child: new Text(
        widget.value.readings[index].toString(),
        style: InputButtonStyle(valueSize, fg),
      ),
      onPressed: () {
        setState(() {
          widget.value.index = index;
        });
      },
      color: bg,
      shape: ButtonShape(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value.allInRange()) {
      doneButtonColour = Colors.black;
      doneButtonEnabled = true;
    } else {
      doneButtonColour = Colors.black26;
      doneButtonEnabled = false;
    }
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Input - ${widget.value.title()}',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.value.readings[0].getTitle(),
                style: HeadingDataStyle(),
              ),
              Text(widget.value.readings[1].getTitle(), style: HeadingDataStyle()),
              Text(widget.value.readings[2].getTitle(), style: HeadingDataStyle()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              valueButton(0),
              valueButton(1),
              valueButton(2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(7),
              button(8),
              button(9),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(4),
              button(5),
              button(6),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(1),
              button(2),
              button(3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.remove_circle_outline, size: numberSize, color: numberColour),
                label: Text(""),
                onPressed: () {
                  setState(() {
                    widget.value.clear();
                  });
                },
                color: backgroundColour,
                shape: ButtonShape(),
              ),
              button(0),
              FlatButton.icon(
                icon: Icon(Icons.backspace, size: numberSize, color: numberColour),
                label: Text(""),
                onPressed: () {
                  setState(() {
                    widget.value.del();
                  });
                },
                color: backgroundColour,
                shape: ButtonShape(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: new Text(
                  "CANCEL",
                  style: InputButtonStyle(okButtonSize, Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: backgroundColour,
                shape: ButtonShape(),
              ),
              FlatButton(
                child: new Text(
                  "OK",
                  style: InputButtonStyle(okButtonSize, doneButtonColour),
                ),
                onPressed: () {
                  if (doneButtonEnabled) {
                    EntryList.add(BPEntry(DateTime.now(), widget.value.val(0), widget.value.val(1), widget.value.val(2), false));
                    Navigator.pop(context);
                  }
                },
                color: doneButtonEnabled ? Colors.lightGreen : backgroundColour,
                shape: ButtonShape(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
