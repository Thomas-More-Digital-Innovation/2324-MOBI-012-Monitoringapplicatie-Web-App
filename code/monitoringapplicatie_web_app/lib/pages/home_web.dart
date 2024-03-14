import 'package:flutter/material.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import './Test_List/Patient.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  // test data voor enkele patienten
  List<Patient> patients = [
    Patient(userId: '1', name: 'user1', lastUsed: DateTime(2024, 1, 23, 17, 30)),
    Patient(userId: '2', name: 'user2', lastUsed: DateTime(2024, 1, 23, 13, 20)),
    Patient(userId: '3', name: 'user3', lastUsed: DateTime(2024, 1, 13, 19, 58)),
    Patient(userId: '4', name: 'user4', lastUsed: DateTime(2024, 2, 2, 9, 24)),
    Patient(userId: '5', name: 'user5', lastUsed: DateTime(2024, 2, 23, 21, 30)),
    Patient(userId: '6', name: 'user6', lastUsed: DateTime(2024, 2, 23, 23, 10)),
    Patient(userId: '7', name: 'user7', lastUsed: DateTime(2024, 2, 17, 7, 17)),
    Patient(userId: '8', name: 'user8', lastUsed: DateTime(2023, 11, 6, 15, 24)),
    Patient(userId: '9', name: 'user9', lastUsed: DateTime(2023, 9, 30, 9, 30)),
    Patient(userId: '10', name: 'user10', lastUsed: DateTime(2023, 10, 23, 8, 30)),
  ];

  String calculateTimeDifference(DateTime lastUsed) {
    // calculeer het verschil tussen de laatste keer gebruikt en nu
    Duration difference = DateTime.now().difference(lastUsed);

    // check of de gepasseerde tijd meer dan een minuut, uur of dag geleden is
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {

    // maak een kopie van de patienten lijst en sorteer deze
    List<Patient> mostRecentPatients = List.from(patients);
    mostRecentPatients.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

    // Take the top 5 most recent patients
    mostRecentPatients = mostRecentPatients.take(4).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Nav(),
            ), // Gebruik de Nav-widget hier
            Column(
              children: [
                const Text(
                  'Home',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60,),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Row(
                      children: [
                        // collom van de 4 meest recente patiënten
                        Expanded(
                            flex: 4,
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Laatste actieve patiënten', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                const Divider(),
                                Container(
                                  height: 312.0,
                                  child: ListView(
                                    children: mostRecentPatients.map((patient) {
                                      return Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                // laat de patient zijn data zien
                                                children: [
                                                  Text(patient.userId),
                                                  const SizedBox(width: 10,),
                                                  Text(patient.name),
                                                  const SizedBox(width: 10,),
                                                  Text(calculateTimeDifference(patient.lastUsed)),
                                                  const Row(
                                                    children: [
                                                      // knop naar de patients statistieken
                                                      IconButton(
                                                        icon: const Icon(Icons.bar_chart_outlined, color: Colors.black,),
                                                        tooltip: 'View Charts',
                                                        onPressed: null,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      // knop naar de patients sensoren
                                                      IconButton(
                                                        icon: const Icon(Icons.sensors_rounded, color: Colors.black,),
                                                        tooltip: 'View Sensors',
                                                        onPressed: null,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                        ),
                        const SizedBox(width: 60,),
                        // collom met alle patiënten
                        Expanded(
                            flex: 4,
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Mijn patiënten', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                const Divider(),
                                Container(
                                  height: 312.0,
                                  child: ListView(
                                    children: patients.map((patient) {
                                      return Card(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                // Laat de patient zijn data zien
                                                children: [
                                                  Text(patient.userId),
                                                  const SizedBox(width: 10,),
                                                  Text(patient.name),
                                                  const SizedBox(width: 10,),
                                                  Text(calculateTimeDifference(patient.lastUsed)),
                                                  const Row(
                                                    children: [
                                                      // knop naar patient's statistieken
                                                      IconButton(
                                                        icon: const Icon(Icons.bar_chart_outlined, color: Colors.black,),
                                                        tooltip: 'View Charts',
                                                        onPressed: null,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      // knop naar patient's sensoren
                                                      IconButton(
                                                        icon: const Icon(Icons.sensors_rounded, color: Colors.black,),
                                                        tooltip: 'View Sensors',
                                                        onPressed: null,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
