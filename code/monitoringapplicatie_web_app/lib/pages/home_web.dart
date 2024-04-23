import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  Map<String, List<String>> userSensors = {};
  late TextEditingController _searchController;
  late String
  currentUser; // assuming you store current user ID or username here

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    currentUser =
    "currentUserId"; // replace this with actual current user ID or username
  }



  @override
  Widget build(BuildContext context) {

    // maak een kopie van de patienten lijst en sorteer deze
    //List<Patient> mostRecentPatients = List.from(patients);
    //mostRecentPatients.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

    // Take the top 5 most recent patients
    //mostRecentPatients = mostRecentPatients.take(4).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Nav(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: getLattestPatienten(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  const Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            final patients = snapshot.data!.docs;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  //0: IntrinsicColumnWidth(),
                                  0: FixedColumnWidth(300),
                                  1: FixedColumnWidth(270),
                                  2: FixedColumnWidth(100),
                                },
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                children: [
                                  const TableRow(
                                    children: <Widget>[
                                      Expanded(flex: 2, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Naam',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                      Expanded(flex: 2, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Laast ingelogd',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                      Expanded(flex: 1, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Acties", style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                    ],
                                  ),
                                  for (var patient in patients)
                                    TableRow(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                  patient['name'].toString())),),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(_getLastSignedIn(
                                                  patient['lastSignedIn']))),),
                                        const Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              // knop naar de patients statistieken
                                              IconButton(
                                                icon: Icon(
                                                  Icons.bar_chart_outlined,
                                                  color: Colors.black,),
                                                tooltip: 'View Charts',
                                                onPressed: null,
                                              ),
                                              SizedBox(width: 5,),
                                              // knop naar de patients sensoren
                                              IconButton(
                                                icon: Icon(
                                                  Icons.sensors_rounded,
                                                  color: Colors.black,),
                                                tooltip: 'View Sensors',
                                                onPressed: null,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: getPatienten(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  const Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            final patients = snapshot.data!.docs;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  //0: IntrinsicColumnWidth(),
                                  0: FixedColumnWidth(300),
                                  1: FixedColumnWidth(270),
                                  2: FixedColumnWidth(100),
                                },
                                defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                                children: [
                                  const TableRow(
                                    children: <Widget>[
                                      Expanded(flex: 2, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Naam',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                      Expanded(flex: 2, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Laast ingelogd',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                      Expanded(flex: 1, child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Acties", style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                          textAlign: TextAlign.left,),),),
                                    ],
                                  ),
                                  for (var patient in patients)
                                    TableRow(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                  patient['name'].toString())),),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(_getLastSignedIn(
                                                  patient['lastSignedIn']))),),
                                        const Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              // knop naar de patients statistieken
                                              IconButton(
                                                icon: Icon(
                                                  Icons.bar_chart_outlined,
                                                  color: Colors.black,),
                                                tooltip: 'View Charts',
                                                onPressed: null,
                                              ),
                                              SizedBox(width: 5,),
                                              // knop naar de patients sensoren
                                              IconButton(
                                                icon: Icon(
                                                  Icons.sensors_rounded,
                                                  color: Colors.black,),
                                                tooltip: 'View Sensors',
                                                onPressed: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to calculate time difference
  String _getLastSignedIn(Timestamp? lastLoggedIn) {
    if (lastLoggedIn == null) {
      return 'User heeft zich nog niet aangemeld';
    } else {
      DateTime lastLoggedInTime = lastLoggedIn.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(lastLoggedInTime);
      if (difference.inMinutes < 60) {
        int minutesDifference = difference.inMinutes;
        return '$minutesDifference min geleden';
      } else {
        int hoursDifference = difference.inHours;
        return '$hoursDifference uur geleden';
      }
    }
  }

  Future<QuerySnapshot> getPatienten() async {
    try {
      // Haal de huidige ingelogde gebruiker op
      User currentUser = FirebaseAuth.instance.currentUser!;

      // Controleer of er een gebruiker is ingelogd
      if (currentUser != null) {
        // Haal de naam op van de ingelogde gebruiker
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('sd-dummy-users')
            .doc(currentUser.uid)
            .get();

        String responsibleName = userSnapshot['name'];
        // Gebruik de UID van de huidige gebruiker om patiënten op te halen
        return await FirebaseFirestore.instance
            .collection('sd-dummy-users')
            .where('role', isEqualTo: 'Patiënt')
            .where("responsible",
            isEqualTo: responsibleName) // Gebruik currentUser.uid
            .get();
      } else {
        // Als er geen gebruiker is ingelogd, gooi een foutmelding
        throw 'Geen gebruiker ingelogd';
      }
    } catch (e) {
      print('Fout bij het ophalen van patiëntengegevens: $e');
      throw e;
    }
  }

  Future<QuerySnapshot> getLattestPatienten() async {
    try {
      // Haal de huidige ingelogde gebruiker op
      User currentUser = FirebaseAuth.instance.currentUser!;

      // Controleer of er een gebruiker is ingelogd
      if (currentUser != null) {
        // Haal de naam op van de ingelogde gebruiker
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('sd-dummy-users')
            .doc(currentUser.uid)
            .get();

        String responsibleName = userSnapshot['name'];
        // Gebruik de UID van de huidige gebruiker om patiënten op te halen
        return await FirebaseFirestore.instance
            .collection('sd-dummy-users')
            .where('role', isEqualTo: 'Patiënt')
            .where("responsible",
            isEqualTo: responsibleName) // Gebruik currentUser.uid
            .get();
      } else {
        // Als er geen gebruiker is ingelogd, gooi een foutmelding
        throw 'Geen gebruiker ingelogd';
      }
    } catch (e) {
      print('Fout bij het ophalen van patiëntengegevens: $e');
      throw e;
    }
  }

  // Future<QuerySnapshot> getPatienten() async {
  //   QuerySnapshot patientenSnapshot =
  //   await FirebaseFirestore.instance.collection('sd-dummy-users').get();
  //   for (QueryDocumentSnapshot patientSnapshot in patientenSnapshot.docs) {
  //     String patientID = patientSnapshot.id;
  //     print('Patient ID: $patientID');
  //
  //     QuerySnapshot sensorsSnapshot = await FirebaseFirestore.instance
  //         .collection('sd-dummy-users/$patientID/sensors')
  //         .get();
  //
  //     List<String> sensorIDs = [];
  //
  //     for (QueryDocumentSnapshot sensorSnapshot in sensorsSnapshot.docs) {
  //       String sensorID = sensorSnapshot.id;
  //       if (sensorSnapshot.exists) {
  //         sensorIDs.add(sensorID);
  //
  //         // Voeg hier verdere verwerking toe, indien nodig
  //       } else {
  //         print('Geen sensor data gevonden voor Sensor ID: $sensorID');
  //       }
  //     }
  //
  //     userSensors[patientID] = sensorIDs;
  //   }
  //
  //   // Print de map buiten de loop om de volledige map te zien
  //   print('Alle gebruikerssensoren: $userSensors');
  //
  //   return patientenSnapshot;
  // }

  Future<QuerySnapshot> getRoles() async {
    return await FirebaseFirestore.instance.collection('roles').get();
  }
}
