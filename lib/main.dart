import 'package:bp_app/settings/maintenance.dart';
import 'package:bp_app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'data/list_entry.dart';
import 'graph/graph_page.dart';
import 'input/detail_page.dart';
import 'input/input_page.dart';
import 'main_page.dart';

void main() {
  runApp(BPApp());
}

class BPApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [routeObserver],
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        "/input": (context) => InputPage(),
        "/detail": (context) => DetailPage(),
        "/settings": (context) => SettingsPage(),
        "/graph": (context) => BpGraph(),
        "/maintenance": (context) => MaintenancePage(),
      },
    );
  }
}
