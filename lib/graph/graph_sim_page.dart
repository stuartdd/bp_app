import 'dart:ui';
import 'package:bp_app/data/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import '../styles.dart';
import 'graph_tools.dart';

class BpGraphSimple extends StatelessWidget {
  final bool pm;
  final int entryCount;
  final bool showPulse;
  final bool showAlt;

  BpGraphSimple(this.pm, this.entryCount, this.showPulse, this.showAlt);

  @override
  Widget build(BuildContext context) {
    double canvasWidth = deriveWidth(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Graphs ${pm ? "PM" : "AM"} - ${EntryList.getName()}',
          style: TitleStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CustomPaint(
          painter: GraphPainter2.buildGraph(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, pm, entryCount, showPulse, showAlt),
          child: Container(
            width: (MediaQuery.of(context).size.width),
            height: (MediaQuery.of(context).size.height),
          ),
        ),
      ),
    );
  }
}

const pulseColor = Colors.red;
const sysColor = Colors.green;
const diaColor = Colors.blue;

const altPulseColor = Colors.red;
const altSysColor = Colors.green;
const altDiaColor = Colors.blue;

const bgColor = Colors.yellow;

const double X_OFS = 15;
const double Y_OFS = 15;

const double weight1 = 3;
const double weight2 = 1;

class GraphPainter2 extends CustomPainter {
  final List<BPEntry> list1;
  final List<BPEntry> list2;
  final int maxLen;
  final bool pm;

  final double xScale;
  final double yScale;
  final double xBase;
  final double yBase;

  final bool showPulse;
  final bool showAlt;

  GraphPainter2(this.list1, this.list2, this.maxLen, this.xScale, this.yScale, this.xBase, this.yBase, this.pm, this.showPulse, this.showAlt);

  static GraphPainter2 buildGraph(double width, double height, bool pm, int entryCount, bool showPulse, bool showAlt) {
    List<BPEntry> list1 = [];
    List<BPEntry> list2 = [];
    int min = 1000;
    int max = -1000;
    for (EntryWithId id in EntryList.cloneListAMPM(pm, entryCount)) {
      if (id is BPEntry) {
        list1.add(id);
        if (id.max() > max) {
          max = id.max();
        }
        if (id.min() < min) {
          min = id.min();
        }
      }
    }
    if (showAlt) {
      for (EntryWithId id in EntryList.cloneListAMPM(!pm, list1.length)) {
        if (id is BPEntry) {
          list2.add(id);
          if (id.max() > max) {
            max = id.max();
          }
          if (id.min() < min) {
            min = id.min();
          }
        }
      }
    }
    int len = math.max(list1.length, list2.length);
    min = min - 38;
    max = max + 6;
    if (len < 2) {
      return null;
    }
    double diff = max.toDouble() - min.toDouble();
    double xScale = (width - 20) / len;
    double yScale = height / diff;
    return GraphPainter2(list1, list2, len, xScale, yScale, X_OFS, height + (min * yScale), pm, showPulse, showAlt);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = bgColor[100];
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    double xStep = size.width / maxLen;
    double ypPrev = 0;
    double ysPrev = 0;
    double ydPrev = 0;
    double xDistPrev = 0;
    double xDist = X_OFS;
    if (showAlt) {
      paint.strokeWidth = weight2;
      for (int x = 0; x < list2.length; x++) {
        double yp = list2[x].pulse.toDouble() * yScale;
        double ys = list2[x].systolic.toDouble() * yScale;
        double yd = list2[x].diastolic.toDouble() * yScale;
        if (x > 0) {
          if (showPulse) {
            paint.color = altPulseColor;
            canvas.drawLine(Offset(xDistPrev, yBase - ypPrev), Offset(xDist, yBase - yp), paint);
          }
          paint.color = altSysColor;
          canvas.drawLine(Offset(xDistPrev, yBase - ysPrev), Offset(xDist, yBase - ys), paint);
          paint.color = altDiaColor;
          canvas.drawLine(Offset(xDistPrev, yBase - ydPrev), Offset(xDist, yBase - yd), paint);
        }
        xDistPrev = xDist;
        ypPrev = yp;
        ysPrev = ys;
        ydPrev = yd;
        xDist = xDist + xStep;
      }
    }

    ypPrev = 0;
    ysPrev = 0;
    ydPrev = 0;
    xDistPrev = 0;
    xDist = X_OFS;
    paint.strokeWidth = weight1;
    for (int x = 0; x < list1.length; x++) {
      double yp = list1[x].pulse.toDouble() * yScale;
      double ys = list1[x].systolic.toDouble() * yScale;
      double yd = list1[x].diastolic.toDouble() * yScale;
      if (x > 0) {
        if (showPulse) {
          paint.color = pulseColor;
          canvas.drawLine(Offset(xDistPrev, yBase - ypPrev), Offset(xDist, yBase - yp), paint);
        }
        paint.color = sysColor;
        canvas.drawLine(Offset(xDistPrev, yBase - ysPrev), Offset(xDist, yBase - ys), paint);
        paint.color = diaColor;
        canvas.drawLine(Offset(xDistPrev, yBase - ydPrev), Offset(xDist, yBase - yd), paint);
      }

      xDistPrev = xDist;
      ypPrev = yp;
      ysPrev = ys;
      ydPrev = yd;
      xDist = xDist + xStep;
    }

    paint.strokeWidth = weight2;
    paint.color = Colors.black;
    canvas.drawLine(Offset(0, size.height - (TXT_SIZE * 3.2)), Offset(size.width, size.height - (TXT_SIZE * 3.2)), paint);

    tp("Showing $maxLen ${pm ? "Evening" : "Morning"} readings.", size, Colors.black).paint(canvas, Offset(xBase + 10, size.height - (TXT_SIZE * 3)));
    tp("Systolic", size, sysColor).paint(canvas, Offset(xBase + 10, size.height - (TXT_SIZE * 2)));
    tp("Diastolic", size, diaColor).paint(canvas, Offset(xBase + ((size.width / 4) * 1), size.height - (TXT_SIZE * 2)));
    if (showPulse) {
      tp("Pulse", size, pulseColor).paint(canvas, Offset(xBase + ((size.width / 4) * 2), size.height - (TXT_SIZE * 2)));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
