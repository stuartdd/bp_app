import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class SettingsPage extends StatefulWidget {
  String statusText = "";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: EntryList.getName());
  }

  Card makeCard(String label, Widget inputWidget) {
    String l = label + "                          ".substring(0, 12 - label.length) + ": ";
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            l,
            style: GoogleFonts.robotoMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          inputWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Settings',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            makeCard(
              "User ID",
              SizedBox(
                width: 150,
                child: TextField(
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  controller: nameController,
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        EntryList.setName(value);
                      } else {
                        nameController.text = EntryList.getName();
                      }
                    });
                  },
                ),
              ),
            ),
            makeCard(
                "Show Hidden",
                Checkbox(
                    value: EntryList.getDontHide(),
                    onChanged: (v) {
                      setState(() {
                        EntryList.setDontHide(v);
                      });
                    })),
            BlackDivider(),
            FlatButton(
              child: new Text(
                "View Morning Graphs (AM)",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/graphAm");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            FlatButton(
              child: new Text(
                "View Evening Graphs (PM)",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/graphPm");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            FlatButton(
              child: new Text(
                "View Morning Graphs + Pulse (AM)",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/graphAmBp");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            FlatButton(
              child: new Text(
                "View Evening Graphs + Pulse (PM)",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/graphPmBp");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            BlackDivider(),
            FlatButton(
              child: new Text(
                "WRITE DATA TO BACKUP",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                setState(() {
                  EntryList.save(true);
                  widget.statusText = "Backup data saved!";
                });
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            FlatButton(
              child: new Text(
                "MAINTENANCE",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/maintenance");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            ClearDivider(),
            Text(
              widget.statusText,
              style: WarnTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
