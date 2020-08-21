import 'dart:ui';
import 'dart:math' as math;
import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../styles.dart';

class BpGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double canvasWidth = deriveWidth(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Graphs - ${EntryList.getName()}',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CustomPaint(
          painter: GraphPainter.build(canvasWidth, MediaQuery.of(context).size.height),
          child: Container(
            width: (canvasWidth),
            height: (MediaQuery.of(context).size.height),
          ),
        ),
      ),
    );
  }
}

double deriveWidth(BuildContext context) {
  double screen = MediaQuery.of(context).size.width;
  double req = EntryList.cloneList().length.toDouble() * 50.0;
  if (req > screen) {
    return req;
  }
  return screen;
}

class GraphPainter extends CustomPainter {
  final List<BPEntry> list;
  final BPEntry youngest;
  final BPEntry oldest;
  final double span;
  final double xScale;
  final double yScale;
  final double xBase;
  final double yBase;
  final textStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  GraphPainter(this.list, this.youngest, this.oldest, this.span, this.xScale, this.yScale, this.xBase, this.yBase);

  static GraphPainter build(double width, double height) {
    List<BPEntry> list = [];
    for (EntryWithId id in EntryList.cloneList()) {
      if (id is BPEntry) {
        list.add(id);
      }
    }
    if (list.length < 2) {
      return null;
    }
    BPEntry youngest = list[0];
    BPEntry oldest = list[list.length - 1];
    double span = (youngest.getId() - oldest.getId()).toDouble().abs();
    double xScale = (width - 20) / span;
    double yScale = height / 250;
    print("size:${list.length} youngest:${youngest.getId()} oldest:${oldest.getId()} height:${height} span:$span yScale:${yScale} ");
    return GraphPainter(list, youngest, oldest, span, xScale, yScale, youngest.getId().toDouble(), height - (height / 3));
  }

  static const double r90 = 90 * math.pi / 180;
  static const double r270 = 270 * math.pi / 180;
  static const double r180 = 10 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 1;
    paint.color = Colors.lightGreen;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    paint.color = Colors.black;
    canvas.drawLine(Offset(0, yBase), Offset(size.width, yBase), paint);
    double ypPrev = 0;
    double ysPrev = 0;
    double ydPrev = 0;
    double xDistPrev = 0;


    paint.strokeWidth = 3;
    for (int x = 0; x < list.length; x++) {
      double xDist = (xBase - (list[x].getId())) * xScale;
      double yp = list[x].pulse.toDouble() * yScale;
      double ys = list[x].systolic.toDouble() * yScale;
      double yd = list[x].diastolic.toDouble() * yScale;
      paint.color = Colors.black;
      canvas.drawLine(Offset(xDistPrev, yBase - ypPrev), Offset(xDist, yBase - yp), paint);
      paint.color = Colors.red;
      canvas.drawLine(Offset(xDistPrev, yBase - ysPrev), Offset(xDist, yBase - ys), paint);
      paint.color = Colors.blue;
      canvas.drawLine(Offset(xDistPrev, yBase - ydPrev), Offset(xDist, yBase - yd), paint);
      xDistPrev = xDist;
      ypPrev = yp;
      ysPrev = ys;
      ydPrev = yd;

    }



    canvas.translate(0, size.height-10);
    canvas.rotate(-r90);
    for (int x = 0; x < list.length; x++) {
      double xDist = (xBase - (list[x].getId())) * xScale;
      tp(list[x].dateTimeShort(), size).paint(canvas, Offset(0, xDist));
    }
    canvas.rotate(r90);
    canvas.translate(0, -yBase);
  }

  TextPainter tp(String text, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    return textPainter;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
