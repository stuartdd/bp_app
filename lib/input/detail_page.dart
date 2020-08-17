import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles.dart';

const double FONT_SIZE = 25;

class DetailPage extends StatelessWidget {
  static EntryWithId entry;

  Card makeCard(BuildContext context, String label, String value, Function(EntryWithId s) onChange) {
    String l = label + "                          ".substring(0, 10 - label.length) + ": ";
    return Card(
      color: onChange==null?Colors.white:Colors.white54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            l,
            style: GoogleFonts.robotoMono(
              fontSize: FONT_SIZE,
              fontWeight: FontWeight.bold,
              color: entry.hidden ? Colors.pinkAccent : Colors.green,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (onChange != null) {
                onChange(entry);
              }
            },
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: FONT_SIZE,
                fontWeight: FontWeight.bold,
                color: entry.hidden ? Colors.pinkAccent : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Entry Details',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          makeCard(context, "Date", entry.dateString(), (entry) async {
            DateTime tim = await _selectDate(context, entry.getDate());
            if (tim != null) {
              entry.setDate(tim);
              Navigator.pop(context);
            }
          }),
          makeCard(context, "Time", (entry as BPEntry).timeString(), (entry) async {
            TimeOfDay tim = await _selectTime(context, TimeOfDay.fromDateTime(entry.getDate()));
            if (tim != null) {
              entry.setTime(tim);
              Navigator.pop(context);
            }
          }),
          Text("Click above to change Date or Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.green),),
          makeCard(context, "Systolic", (entry as BPEntry).systolic.toString(), null),
          makeCard(context, "Diastolic", (entry as BPEntry).diastolic.toString(), null),
          makeCard(context, "Pulse", (entry as BPEntry).pulse.toString(), null),
          makeCard(context, "Hidden", entry.hidden ? "YES" : "NO", null),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                child: new Text(
                  "OK",
                  style: ButtonStyle(35, Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.green,
                shape: ButtonShape(),
              ),
              FlatButton(
                child: new Text(
                  entry.hidden ? "UN-HIDE" : "HIDE",
                  style: ButtonStyle(35, Colors.black),
                ),
                onPressed: () {
                  entry.hidden = !entry.hidden;
                  Navigator.pop(context);
                },
                color: Colors.pinkAccent,
                shape: ButtonShape(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      return picked;
    }
  }

  Future<TimeOfDay> _selectTime(BuildContext context, TimeOfDay time) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      return picked;
    }
  }
}
