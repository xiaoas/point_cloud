import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:provider/provider.dart';
import 'models/cloud.dart';
import 'package:http/http.dart' as http;

class CheckPointsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckPointsScreenState();
}

class _CheckPointsScreenState extends State<CheckPointsScreen> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Check Points'),
        ),
        body: Consumer<CheckPointModel>(
            builder: (context, checkPointModel, child) {
          var checkpoints = checkPointModel.checkpoints;
          final tiles = checkpoints.entries.map((entry) => Dismissible(
                key: Key(entry.key),
                onDismissed: (direction) {
                  checkpoints.remove(entry.key);
                },
                child: ListTile(
                  title: Text(
                    entry.key,
                    // style: _biggerFont,
                  ),
                  onLongPress: () {
                    Provider.of<CloudModel>(context, listen: false).points =
                        entry.value;
                    Provider.of<CloudModel>(context, listen: false)
                        .notifyListeners();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Check Point '${entry.key}' loaded.")));
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
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Check Point Name',
                    ),
                    validator: (value) {
                      if (value.isNotEmpty && checkpoints.containsKey(value)) {
                        return "Check Point with Name '$value' already exists.";
                      }
                      return null;
                    },
                    controller: myController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        final newName = myController.text.isEmpty
                            ? DateTime.now().toString()
                            : myController.text;
                        checkpoints[newName] = List.from(
                            Provider.of<CloudModel>(context, listen: false)
                                .points
                                .map((point) => point.clone()));

                        checkPointModel.notifyListeners();
                      }
                    },
                    child: Text('Save'),
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
