import 'package:flutter/material.dart';
import 'quat_calculator.dart';

class QuatPage extends StatefulWidget {
  const QuatPage({super.key, required this.title});

  final String title;

  @override
  State<QuatPage> createState() => _QuatPageState();
}

class _QuatPageState extends State<QuatPage> {
  // Declare the variable
  //0.968, 0.008, -0.008, 0.252 (dummy data for 118 degree)
  //0.382, 0.605,  0.413, 0.563 (dummy data for 118 degree)
  List<double> quaternion1 = [
    0.67826873,
    -0.0062600286,
    0.02084213,
    -0.7344916
  ];
  List<double> quaternion2 = [
    0.8766432,
    -0.0017444739,
    0.011560617,
    -0.48099923
  ];

  @override
  Widget build(BuildContext context) {
    qautToAngle(quaternion1, quaternion2);

    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          // Display the variable on the screen
          Text('Resulting angle: hello world'),
        ],
      ),
    );
  }
}
