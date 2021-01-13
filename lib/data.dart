import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:provider/provider.dart';
import 'models/cloud.dart';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DataState();
}

class _DataState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  static const axes = ['x', 'y', 'z'];
  final myController = {
    'x': TextEditingController(),
    'y': TextEditingController(),
    'z': TextEditingController()
  };

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.values.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data'),
        ),
        body: Consumer<CloudModel>(builder: (context, cloudModel, child) {
          var points = cloudModel.points;
          final tiles = points.map((point) => Dismissible(
                key: Key(point.toString()),
                onDismissed: (direction) {
                  points.remove(point);
                },
                child: ListTile(
                  title: Text(
                    point.toString(),
                    // style: _biggerFont,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Point Edit'),
                        content: Form(
                          // key: _formKey,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ...axes
                                  .map((axName) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: 'coord',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Please specify Point $axName value";
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return "Invalid double value'$value'";
                                              }
                                              return null;
                                            },
                                            controller: myController[axName],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              if (Form.of(context).validate()) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ));
          final divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          var form = Form(
            key: _formKey,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ...axes
                    .map((axName) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Coordinate',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please specify Point $axName value";
                                }
                                if (double.tryParse(value) == null) {
                                  return "Invalid double value'$value'";
                                }
                                return null;
                              },

                              controller: myController[axName],
                            ),
                          ),
                        ))
                    .toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        final xyz = axes
                            .map((axstr) {
                          final controller = myController[axstr];
                          final value = double.parse(controller.text);
                          controller.clear();
                          return value;
                        })
                            .toList();
                        points.add(Vector3(xyz[0], xyz[1], xyz[2]));
                        cloudModel.notifyListeners();
                      }
                    },
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          );
          return Column(
            children: [
              form,
              Divider(),
              Expanded(
                child: ListView(children: divided),
              ),
            ],
          );
        }));
  }
}
