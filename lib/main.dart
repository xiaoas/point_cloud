import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show Vector3;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('test'),
        ),
        body: PointCloud(),
      )
    );
  }
}

class PointCloud extends StatefulWidget {
  PointCloud({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PointCloudState();
}
class _PointCloudState extends State<PointCloud> {
  final points = <Vector3>[
    Vector3.zero(),
    Vector3(1, 2, 3),
  ];

  // final viewpoint;
  @override
  Widget build(BuildContext context) {
    var random = Random();
    return Stack(
      children: points
          .map((coord) => Draggable(
                child: Container(
                  padding: EdgeInsets.only(top: coord.y, left: coord.x),
                  child: Point(),
                ),
                feedback: Container(
                  padding: EdgeInsets.only(top: coord.y, left: coord.x),
                  child: Point(),
                ),
                childWhenDragging: Container(),
                onDragCompleted: () {},
                onDragEnd: (drag) {
                  setState(() {
                    // top[0] = top[0] + drag.offset.dy < 0 ? 0 : top[0] + drag.offset.dy;
                    // left[0] = left[0] + drag.offset.dx < 0 ? 0 : left[0] + drag.offset.dx;
                  });
                },
              ))
          .toList(),
    );
  }
}
// Positioned(
// left: random.nextInt(30).toDouble(),
// top: random.nextInt(30).toDouble(),
// child: Point(),
// )

class Point extends StatelessWidget {
  final int index;

  Point({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Container(
        padding: EdgeInsets.only(top: coord.y, left: coord.x),
        child: Point(),
      ),
      feedback: Container(
        padding: EdgeInsets.only(top: coord.y, left: coord.x),
        child: Point(),
      ),
      childWhenDragging: Container(),
      onDragCompleted: () {},
      onDragEnd: (drag) {
        setState(() {
          // top[0] = top[0] + drag.offset.dy < 0 ? 0 : top[0] + drag.offset.dy;
          // left[0] = left[0] + drag.offset.dx < 0 ? 0 : left[0] + drag.offset.dx;
        });
      },
    );
  }

  Widget _buildDot() {
    return Icon(
      IconData(57744, fontFamily: 'MaterialIcons'),
      size: 36,
    );
  }
}


// following remain unused

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        Flexible(
          flex: 1,
          child: AspectRatio(aspectRatio: 1, child: Placeholder()),
        ),
        Divider(),
        Flexible(
          flex: 1,
          child: AspectRatio(aspectRatio: 1, child: Placeholder()),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
