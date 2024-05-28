import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:monitoringapplicatie_web_app/pages/quat_calculator.dart';

void main() {
  runApp(WebPage());
}

class WebPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RevAPP WEB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Nav(),
              ),
              Column(
                children: [
                  const Text(
                    'Statistieken Patient X',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextSwitcher(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextSwitcher extends StatefulWidget {
  @override
  _TextSwitcherState createState() => _TextSwitcherState();
}

class _TextSwitcherState extends State<TextSwitcher> {
  int _selectedTextIndex = 0;

  static List<Widget> _textOptions = <Widget>[
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(50),
      child: FutureBuilder<List<dynamic>>(
          future: Future.wait([getUserSensorData1(), getUserSensorData2()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            List<dynamic> quaternionen1 = snapshot.data![0];
            List<dynamic> quaternionen2 = snapshot.data![1];
            print(quaternionen1);
            print(quaternionen2);
            print('has quaternions');

            List<dynamic> hoeken = combineQuaternions(quaternionen1, quaternionen2);


            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Maximum Hoek',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  '${hoeken.isEmpty ? "No data" : hoeken[0].toStringAsFixed(2)}°',
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
    ),
    FractionallySizedBox(
      widthFactor: 0.5,  // Width is 50% of the parent
      child: ExerciseChart(),
    ),
  ];

  void _selectText(int index) {
    setState(() {
      _selectedTextIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _textOptions.elementAt(_selectedTextIndex),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectText(0),
              child: Text('Max. Hoek'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _selectText(1),
              child: Text('Oefening'),
            ),
          ],
        ),
      ],
    );
  }
}

class ExerciseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: 'cycli'),
        minimum: 1,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Hoek (°)'),
        minimum: 70,
        maximum: 110,
      ),
      series: <LineSeries<ExerciseData, double>>[
        LineSeries<ExerciseData, double>(
          dataSource: getExerciseData(),
          xValueMapper: (ExerciseData data, _) => data.time,
          yValueMapper: (ExerciseData data, _) => data.value,
        )
      ],
    );
  }

  // delete later (dummy data)
  List<ExerciseData> getExerciseData() {
    return [
      ExerciseData(1, 70),
      ExerciseData(2, 75),
      ExerciseData(3, 72),
      ExerciseData(4, 78),
      ExerciseData(5, 83),
      ExerciseData(6, 79),
      ExerciseData(7, 86),
      ExerciseData(8, 89),
      ExerciseData(9, 95),
      ExerciseData(10, 100),
    ];
  }
}

class ExerciseData {
  ExerciseData(this.time, this.value);
  final double time;
  final double value;
}

Future<List<dynamic>> getUserSensorData1() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot userDocument = await firestore
      .collection('sd-dummy-users')
      .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
      .get();

  if (userDocument.exists) {
    QuerySnapshot sensorsSnapshot = await firestore
        .collection('sd-dummy-users')
        .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
        .collection('sensors')
        .get();

    for (var sensorDoc in sensorsSnapshot.docs) {
      if (sensorDoc.id == 'D4:22:CD:00:92:2E') {
        QuerySnapshot sessionSnapshot = await firestore
            .collection('sd-dummy-users')
            .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
            .collection('sensors')
            .doc(sensorDoc.id)
            .collection('session5')
            .orderBy("sessionTime")
            .get();

        List<dynamic> quaternionen = sessionSnapshot.docs.map((doc) => doc['quat']).toList();
        return quaternionen;


        /*sessionSnapshot.docs.forEach((doc) {
          print('Session data: ${doc.data()}');
        });*/
      }
    }
  } else {
    print('No user found with name Toon');
  }
  return [];
}

Future<List<dynamic>> getUserSensorData2() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot userDocument = await firestore
      .collection('sd-dummy-users')
      .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
      .get();

  if (userDocument.exists) {
    QuerySnapshot sensorsSnapshot = await firestore
        .collection('sd-dummy-users')
        .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
        .collection('sensors')
        .get();

    for (var sensorDoc in sensorsSnapshot.docs) {
      if (sensorDoc.id == 'D4:22:CD:00:92:25') {
        QuerySnapshot sessionSnapshot = await firestore
            .collection('sd-dummy-users')
            .doc('ChApbk30XlNl1no5ToIyI3UEYhg2')
            .collection('sensors')
            .doc(sensorDoc.id)
            .collection('session5')
            .orderBy("sessionTime")
            .get();

        List<dynamic> quaternionen = sessionSnapshot.docs.map((doc) => doc['quat']).toList();
        return quaternionen;


        /*sessionSnapshot.docs.forEach((doc) {
          print('Session data: ${doc.data()}');
        });*/
      }
    }
  } else {
    print('No user found with name Toon');
  }
  return [];
}

// combine lists of quaternions to one list (degrees)
List<List<double>> parseQuaternions(List<dynamic> quaternionen) {
  return quaternionen.map<List<double>>((quaternion) {
    // Remove leading and trailing square brackets and split by comma
    List<String> quaternionValues = quaternion.substring(1, quaternion.length - 1).split(',');

    // Parse each value to double
    return quaternionValues.map((value) => double.parse(value)).toList();
  }).toList();
}

List<double> combineQuaternions(List<dynamic> quaternionen1, List<dynamic> quaternionen2) {
  List<List<double>> parsedQuaternions1 = parseQuaternions(quaternionen1);
  List<List<double>> parsedQuaternions2 = parseQuaternions(quaternionen2);

  List<double> hoeken = [];

  // Ensure that both lists have the same length
  int minLength = parsedQuaternions1.length < parsedQuaternions2.length
      ? parsedQuaternions1.length
      : parsedQuaternions2.length;

  for (int i = 0; i < minLength; i++) {
    List<double> quaternion1 = parsedQuaternions1[i];
    List<double> quaternion2 = parsedQuaternions2[i];

    double hoek = qautToAngle(quaternion1, quaternion2);
    hoeken.add(hoek);
  }
  hoeken.sort((a, b) => b.compareTo(a));
  return hoeken;
}

