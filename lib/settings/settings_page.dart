import 'package:bp_app/data/settings_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController;
  String statusText = "";

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: SettingsData.userName);
  }

  Card makeCard(String label, Widget inputWidget) {
    String l = label + "                          ".substring(0, 14 - label.length) + ": ";
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
          style: const TitleStyle(),
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
                        SettingsData.userName = value;
                      } else {
                        nameController.text = SettingsData.userName;
                      }
                    });
                  },
                ),
              ),
            ),
            makeCard(
                "Show Hidden",
                Checkbox(
                    value: SettingsData.doNotHide,
                    onChanged: (v) {
                      setState(() {
                        SettingsData.doNotHide = v;
                      });
                    })),
            const BlackDivider(),
            FlatButton(
              child: new Text(
                "Morning Graph (AM)",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/graphAm");
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            makeCard(
                "Show Pulse",
                Checkbox(
                    value: SettingsData.showPulseInGraphs,
                    onChanged: (v) {
                      setState(() {
                        SettingsData.showPulseInGraphs = v;
                      });
                    })),
            const BlackDivider(),
            FlatButton(
              child: new Text(
                "WRITE DATA TO BACKUP",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                setState(() {
                  SettingsData.save(true);
                  statusText = "Backup data saved!";
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
            const ClearDivider(),
            Text(
              statusText,
              style: const WarnTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
