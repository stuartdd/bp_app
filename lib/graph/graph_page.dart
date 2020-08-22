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

const pulseColor = Colors.red;
const sysColor = Colors.green;
const diaColor = Colors.blue;
const bgColor = Colors.yellow;
const double r90 = 90 * math.pi / 180;
const double TXT_SIZE = 19;
const double xOfs = 15;

class GraphPainter extends CustomPainter {
  final List<BPEntry> list;
  final BPEntry youngest;
  final BPEntry oldest;
  final double span;
  final double xScale;
  final double yScale;
  final double xBase;
  final double yBase;


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
    double yScale = height / 300;
    return GraphPainter(list, youngest, oldest, span, xScale, yScale, youngest.getId().toDouble(), height - (height / 3));
  }


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 1;
    paint.color = bgColor[100];
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
      paint.strokeWidth = 1;
      paint.color = Colors.black;
      double xDist = xOfs + ((xBase - (list[x].getId())) * xScale);
      canvas.drawLine(Offset(xDist, yBase), Offset(xDist, 0), paint);
      paint.strokeWidth = 3;
      double yp = list[x].pulse.toDouble() * yScale;
      double ys = list[x].systolic.toDouble() * yScale;
      double yd = list[x].diastolic.toDouble() * yScale;
      if (x > 0) {
        paint.color = pulseColor;
        canvas.drawLine(Offset(xDistPrev, yBase - ypPrev), Offset(xDist, yBase - yp), paint);
        paint.color = sysColor;
        canvas.drawLine(Offset(xDistPrev, yBase - ysPrev), Offset(xDist, yBase - ys), paint);
        paint.color = diaColor;
        canvas.drawLine(Offset(xDistPrev, yBase - ydPrev), Offset(xDist, yBase - yd), paint);
      }
      tp(list[x].pulse.toString(), size, pulseColor).paint(canvas, Offset(xDist, yBase - yp));
      tp(list[x].systolic.toString(), size, sysColor).paint(canvas, Offset(xDist, yBase - ys));
      tp(list[x].diastolic.toString(), size, diaColor).paint(canvas, Offset(xDist, yBase - yd));

      if ((x % 8) == 0) {
        tp("Pulse", size, pulseColor).paint(canvas, Offset(xDist+10, yBase-TXT_SIZE*1.4));
        tp("Systolic", size, sysColor).paint(canvas, Offset(xDist+10, yBase-(TXT_SIZE*2.4)));
        tp("Diastolic", size, diaColor).paint(canvas, Offset(xDist+10, yBase-(TXT_SIZE*3.4)));
      }

      xDistPrev = xDist;
      ypPrev = yp;
      ysPrev = ys;
      ydPrev = yd;
    }

    canvas.translate(0, size.height - 10);
    canvas.rotate(-r90);
    for (int x = 0; x < list.length; x++) {
      double xDist = (xBase - (list[x].getId())) * xScale;
      tp(list[x].dateTimeShort(), size, Colors.black).paint(canvas, Offset(0, xDist));
    }
    canvas.rotate(r90);
    canvas.translate(0, -yBase);
  }

  TextPainter tp(String text, Size size, Color c) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: c,
        fontSize: TXT_SIZE,
      ),
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
