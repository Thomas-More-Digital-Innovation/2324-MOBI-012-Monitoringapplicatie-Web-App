import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  final String patientID;

  const Dashboard({Key? key, required this.patientID}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> sessionsData = [];

  @override
  void initState() {
    super.initState();
    // Haal gegevens op bij het laden van de pagina
    getAndSetSessions();
  }

  // Functie om gegevens op te halen en de staat bij te werken
  Future<void> getAndSetSessions() async {
    List<Map<String, dynamic>> data = await getSessions();
    setState(() {
      sessionsData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: ListView(
          children: [
            Text('Patient ID: ${widget.patientID}'),
            if (sessionsData.isNotEmpty)
              Container(
                height: 500,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    minX: 0,
                    maxX: (sessionsData.length - 1) / 5,
                    minY: -70, // Aanpassen aan je gegevens.
                    maxY: 75, // Aanpassen aan je gegevens.
                    lineBarsData: [
                      LineChartBarData(
                        spots: sessionsData
                            .asMap()
                            .entries
                            .where((entry) => entry.key % 5 == 0)
                            .map((entry) {
                          Map<String, dynamic> session = entry.value;
                          List<double> acc =
                              List.from(json.decode(session['acc']));
                          return FlSpot(entry.key / 5, acc[0]);
                        }).toList(),
                        isCurved: true,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: sessionsData
                            .asMap()
                            .entries
                            .where((entry) => entry.key % 5 == 0)
                            .map((entry) {
                          Map<String, dynamic> session = entry.value;
                          List<double> acc =
                              List.from(json.decode(session['acc']));
                          return FlSpot(entry.key / 5, acc[1]);
                        }).toList(),
                        isCurved: true,
                        color: Colors.red,
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: sessionsData
                            .asMap()
                            .entries
                            .where((entry) => entry.key % 5 == 0)
                            .map((entry) {
                          Map<String, dynamic> session = entry.value;
                          List<double> acc =
                              List.from(json.decode(session['acc']));
                          return FlSpot(entry.key / 5, acc[2]);
                        }).toList(),
                        isCurved: true,
                        color: Colors.green,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    var db = FirebaseFirestore.instance;
    var lastSessionNumber = 1;
    await db
        .collection("sd-dummy-users")
        .doc(widget.patientID)
        .collection("sensors")
        .doc('D4:22:CD:00:92:2E')
        .get()
        .then((documentSnapshot) {
      //If already data in DB
      if (documentSnapshot.exists) {
        Map<String, dynamic> docData =
            documentSnapshot.data() as Map<String, dynamic>;
        lastSessionNumber = docData["lastSessionNumber"];
      }
    });

    QuerySnapshot sessionSnapshot = await FirebaseFirestore.instance
        .collection(
            'sd-dummy-users/${widget.patientID}/sensors/D4:22:CD:00:92:2E/session$lastSessionNumber')
        .orderBy('sessionTime', descending: false)
        .get();

    List<Map<String, dynamic>> dataList = [];

    sessionSnapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      dataList.add(data);
    });

    return dataList;
  }
}
