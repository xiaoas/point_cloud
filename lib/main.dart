import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:provider/provider.dart';
import 'models/cloud.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CloudModel(),
      child: MyApp(),
    ),
  );
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
          body: Column(children: [
            Flexible(
              flex: 1,
              child: AspectRatio(aspectRatio: 1, child: PointCloud()),
            ),
            Divider(),
            Flexible(
              flex: 1,
              child: AspectRatio(aspectRatio: 1, child: Consumer<CloudModel>(
                builder: (context, cloud, child) {
                  final cloudData = jsonEncode(
                      cloud.points.map((Vector3 vec) => [vec.x, vec.y, vec.z])
                          .toList(growable: false));
                  return FutureBuilder(
                    // future: http.get('http://10.0.2.2:8888'),
                    future: http.post('http://10.0.2.2:8888',
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: cloudData
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(snapshot.data.bodyBytes);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return CircularProgressIndicator();
                    },
                  );
                  // return Text(cloud.points[0].xyz.toString());
                }
                ,)
              ),
            )
          ]),
          drawer: Drawer(
            child: ListView(
              // padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Point Cloud',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.label),
                  title: Text('points view'),
                ),
              ],
            ),
          ),
        )
    );
  }
}

// class PointCloudImage extends StatefulWidget {
//   @override
//   _PointCloudImageState createState() => _PointCloudImageState();
// }
//
// class _PointCloudImageState extends State<PointCloudImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Text(key.currentState.points[0].xyz.toString());
//   }
// }

class PointCloud extends StatefulWidget {
  PointCloud({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PointCloudState();
}

class _PointCloudState extends State<PointCloud> {

  // final viewpoint;
  @override
  Widget build(BuildContext context) {
    var random = Random();
    return Consumer<CloudModel>(
        builder: (context, cloud, child) {
          final points = cloud.points;
          return Stack(
              children: List<Widget>.generate(
                  points.length,
                      (int index) =>
                      Draggable(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: points[index].y, left: points[index].x),
                          child: Point(),
                        ),
                        feedback: Container(
                          padding: EdgeInsets.only(
                              top: points[index].y, left: points[index].x),
                          child: Point(),
                        ),
                        childWhenDragging: Container(),
                        onDragCompleted: () {},
                        onDragEnd: (drag) {
                          RenderBox renderBox = context.findRenderObject();
                          final offset = renderBox.globalToLocal(drag.offset);
                          if (offset.dx == 0 && offset.dy == 0) {
                            print("tapped");
                            return;
                          }
                          points[index].y += offset.dy;
                          points[index].y =
                          points[index].y > 0 ? points[index].y : 0;
                          points[index].x += offset.dx;
                          points[index].x =
                          points[index].x > 0 ? points[index].x : 0;
                          // top[index] = top[index] + drag.offset.dy < 0 ? 0 : top[index] + drag.offset.dy;
                          // left[index] = left[index] + drag.offset.dx < 0 ? 0 : left[index] + drag.offset.dx;
                          cloud.notifyListeners();
                        },
                      )));
        }
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
    return Icon(
      Icons.add_circle_outline,
      size: 36,
    );
  }

  Widget _buildDot() {
    return Icon(
      IconData(57744, fontFamily: 'MaterialIcons'),
      size: 36,
    );
  }
}
