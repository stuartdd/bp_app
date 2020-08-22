import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class MaintenancePage extends StatefulWidget {
  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  TextEditingController pasteController;

  @override
  void dispose() {
    pasteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pasteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Maintenance',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ClearDivider(),
            Text("Copy the JSON in the Primary data file to the clipboard and the field below.",
              style: WarnTextStyle(),
            ),
            FlatButton(
              child: new Text(
                "COPY DATA TO CLIPBOARD",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () async {
                String content = await EntryList.copyFileToClipboard(false);
                setState(() {
                  pasteController.text = content;
                });
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            ClearDivider(),
            Text("Copy the JSON in the BACKUP file to the clipboard and the field below.",
              style: WarnTextStyle(),
            ),
            FlatButton(
              child: new Text(
                "COPY BACKUP TO CLIPBOARD",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () async {
                String content = await EntryList.copyFileToClipboard(true);
                setState(() {
                  pasteController.text = content;
                });
              },
              color: Colors.lightBlue,
              shape: ButtonShape(),
            ),
            BlackDivider(),
            Text("The field below is for data maintenance. "
                "Paste JSON data in to this field to IMPORT the data readings.\n\n"
                "Invalid data will be ignored but it is a good idea to save the data to a backup first.",
              style: WarnTextStyle(),
            ),
            TextField(
              maxLines: null,
              controller: pasteController,
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.pink[100],
                filled: true,
                hintText: 'Paste valid data in to this field',
              ),
            ),
            FlatButton(
              child: new Text(
                "READ DATA FROM INPUT ABOVE",
                style: InputButtonStyle(20, Colors.black),
              ),
              onPressed: () {
                setState(() {
                  if (pasteController.text.isNotEmpty) {
                    pasteController.text = EntryList.tryParse(pasteController.text);
                  }
                });
              },
              color: Colors.pinkAccent,
              shape: ButtonShape(),
            ),
            BlackDivider(),
           ],
        ),
      ),
    );
  }
}
