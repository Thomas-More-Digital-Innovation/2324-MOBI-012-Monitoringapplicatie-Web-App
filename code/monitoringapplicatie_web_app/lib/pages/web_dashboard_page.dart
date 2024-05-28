import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Maximum Hoek',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            '112.4°',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
        ],
      ),
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

void getUserSensorData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentSnapshot userDocument = await firestore
      .collection('sd-dummy-users')
      .doc('GXNDW2WtvpSqt1Ly5KQyoy8dAzH2')
      .get();

  if (userDocument.exists) {
    QuerySnapshot sensorsSnapshot = await firestore
        .collection('sd-dummy-users')
        .doc('GXNDW2WtvpSqt1Ly5KQyoy8dAzH2')
        .collection('sensors')
        .get();

    for (var sensorDoc in sensorsSnapshot.docs) {
      if (sensorDoc.id == 'D4:22:CD:00:92:2E') {
        QuerySnapshot sessionSnapshot = await firestore
            .collection('sd-dummy-users')
            .doc('GXNDW2WtvpSqt1Ly5KQyoy8dAzH2')
            .collection('sensors')
            .doc(sensorDoc.id)
            .collection('session1')
            .orderBy("sessionTime")
            .get();

        sessionSnapshot.docs.forEach((doc) {
          print('Session data: ${doc.data()}');
        });
      }
    }
  } else {
    print('No user found with name Seppe');
  }
}
