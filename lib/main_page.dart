import 'package:bp_app/data/list_entry.dart';
import 'package:bp_app/input/detail_page.dart';
import 'package:bp_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteAware {
  Widget _makeCard(BuildContext context, String route, String image) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              "assets/${image}",
            ),
          ],
        ),
      ),
    );
  }

  Color entryBackgroundColor(EntryWithId ent) {
    if (ent.isPM()) {
      return Colors.blue[50];
    }
    return Colors.white;
  }

  Color entryColor(EntryWithId ent) {
    if (ent.hidden) {
      return Colors.pinkAccent;
    } else {
      if (ent.isPM()) {
        return Colors.blue;
      }
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'BP Log - ${EntryList.getName()}',
          style: TitleStyle(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
       ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          _makeCard(context, "/input", "bp.png"),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Column(
                children: EntryList.cloneList().map((e) {
                  return Container(
                    color: entryBackgroundColor(e),
                    child:Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      GestureDetector(
                        onTap: () {
                          DetailPage.entry = EntryList.getEntry((e).getId());
                          Navigator.pushNamed(context, "/detail");
                        },
                        child: Text(
                          e.dateTimeString(),
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: entryColor(e),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          DetailPage.entry = EntryList.getEntry((e).getId());
                          Navigator.pushNamed(context, "/detail");
                        },
                        child: Text(
                          (e as BPEntry).values(),
                          style: GoogleFonts.robotoMono(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: entryColor(e),
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],)
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    EntryList.load(false);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    EntryList.save(false);

    setState(() {});
  }

}
