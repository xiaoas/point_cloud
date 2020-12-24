import 'package:flutter/material.dart';

void main() => runApp(
      new MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable',
      home: Drag(),
    );
  }
}

class Drag extends StatefulWidget {
  Drag({Key key}) : super(key: key);

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  final top = <double>[0, 0];
  final left = <double>[0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Draggable(
              child: Container(
                padding: EdgeInsets.only(top: top[0], left: left[0]),
                child: DragItem(),
              ),
              feedback: Container(
                padding: EdgeInsets.only(top: top[0], left: left[0]),
                child: DragItem(),
              ),
              childWhenDragging: Container(),
              onDragCompleted: () {},
              onDragEnd: (drag) {
                setState(() {
                  top[0] =
                      top[0] + drag.offset.dy < 0 ? 0 : top[0] + drag.offset.dy;
                  left[0] = left[0] + drag.offset.dx < 0
                      ? 0
                      : left[0] + drag.offset.dx;
                });
              },
            ),
            Draggable(
              child: Container(
                padding: EdgeInsets.only(top: top[1], left: left[1]),
                child: DragItem(),
              ),
              feedback: Container(
                padding: EdgeInsets.only(top: top[1], left: left[1]),
                child: DragItem(),
              ),
              childWhenDragging: Container(),
              onDragCompleted: () {},
              onDragEnd: (drag) {
                setState(() {
                  top[1] =
                      top[1] + drag.offset.dy < 0 ? 0 : top[1] + drag.offset.dy;
                  left[1] = left[1] + drag.offset.dx < 0
                      ? 0
                      : left[1] + drag.offset.dx;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(57744, fontFamily: 'MaterialIcons'),
      size: 36,
    );
  }
}
