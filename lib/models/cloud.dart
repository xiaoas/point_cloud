import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector3;

class CloudModel extends ChangeNotifier {
  List<Vector3> points = [
    Vector3.zero(),
    Vector3(8, 20, 30),
    Vector3(30, 5, 0),
    Vector3(0, 25, 12),
    Vector3(39, 24, 31),
    Vector3(6, 46, 41),
    Vector3(30, 29, 13),
    Vector3(36, 51, 41),
  ];
}

class CheckPointModel extends ChangeNotifier {
  final Map<String, List<Vector3>> checkpoints = {};
}