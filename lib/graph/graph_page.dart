import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class BpGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Graphs - ${EntryList.getName()}',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
    );
  }
}
