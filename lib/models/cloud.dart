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
    Vector3(50, 50, 50),
    Vector3(58, 70, 80),
    Vector3(80, 55, 50),
    Vector3(50, 75, 62),
    Vector3(89, 74, 81),
    Vector3(56, 96, 91),
    Vector3(80, 79, 63),
    Vector3(86, 101, 91),
  ];
}

class CheckPointModel extends ChangeNotifier {
  final Map<String, List<Vector3>> checkpoints = {};
}