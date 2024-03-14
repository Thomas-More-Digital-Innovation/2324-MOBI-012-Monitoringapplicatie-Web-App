import 'package:flutter/material.dart';

class Patient {
  final String userId;
  final String name;
  final DateTime lastUsed;

  Patient({required this.userId, required this.name, required this.lastUsed});
}

/*
ListView(
shrinkWrap: true,
children: patients.map((student) {
return Card(
child: Row(
children: [
Text(student.userId),
Text(student.name),
Text(student.lastUsed.toString())
],
),
);
}).toList(),
),
ListView(
shrinkWrap: true,
children: patients.map((student) {
return Card(
child: Row(
children: [
Text(student.userId),
Text(student.name),
Text(student.lastUsed.toString())
],
),
);
}).toList(),
),*/
