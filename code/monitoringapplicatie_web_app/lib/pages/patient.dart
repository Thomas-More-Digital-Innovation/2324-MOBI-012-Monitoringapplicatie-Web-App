import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  Map<String, List<String>> userSensors = {};
  @override
  void initState() {
    super.initState();
    getSensorDataWithHighestSessionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Nav(),
            ),
            FutureBuilder<QuerySnapshot>(
              future: getPatienten(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
                          0: IntrinsicColumnWidth(),
                          2: FixedColumnWidth(64),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          const TableRow(
                            children: <Widget>[
                              Expanded(flex: 2, child: Text('Gebruikersnaam')),
                              Expanded(flex: 2, child: Text('Laast ingelogd')),
                              Expanded(
                                  flex: 2,
                                  child: Text('Laatst data verzonden')),
                              Expanded(
                                flex: 2,
                                child: Text("Actief"),
                              ),
                              Expanded(flex: 1, child: Text("Acties")),
                            ],
                          ),
                          for (var patient in patients)
                            TableRow(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(patient['name'].toString())),
                                Expanded(
                                    flex: 2,
                                    child: Text(_getLastSignedIn(
                                        patient['lastSignedIn']))),
                                Expanded(
                                    flex: 2,
                                    child: Text(_getLastDataSend(
                                        patient['lastDataSend']))),
                                Expanded(
                                    flex: 2,
                                    child: Text(patient['isSignedIn'] == true
                                        ? "Ja"
                                        : "Nee")),
                                Expanded(flex: 1, child: Text("Actions")),
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

  String _getLastDataSend(Timestamp? lastDataSend) {
    if (lastDataSend == null) {
      return 'User heeft nog geen data verstuurd';
    } else {
      DateTime lastDataSendTime = lastDataSend.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(lastDataSendTime);
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
      return await FirebaseFirestore.instance
          .collection('sd-dummy-users')
          .where('role', isEqualTo: 'Patiënt')
          .get();
    } catch (e) {
      print('Fout bij het ophalen van patiëntengegevens: $e');
      throw e;
    }
  }

  Future<Map<String, String>> getSensorDataWithHighestSessionNumber() async {
    Map<String, String> userLatestSession = {};

    try {
      QuerySnapshot patientenSnapshot = await getPatienten();

      for (QueryDocumentSnapshot patientSnapshot in patientenSnapshot.docs) {
        String userId = patientSnapshot['userId'];
        String patientID = patientSnapshot.id;
        // Query om alleen de documenten met de hoogste lastSessionNumber te krijgen
        QuerySnapshot sensorsSnapshot = await FirebaseFirestore.instance
            .collection('sd-dummy-users/$patientID/sensors')
            .orderBy('lastSessionNumber', descending: true)
            .limit(1)
            .get();

        if (sensorsSnapshot.docs.isNotEmpty) {
          String highestSessionNumberDocId = sensorsSnapshot.docs.first.id;
          sensorsSnapshot.docs.first['lastSessionNumber'];
          int highestSessionNumber =
              sensorsSnapshot.docs.first['lastSessionNumber'];
          userLatestSession[userId] =
              '$highestSessionNumberDocId (LastSessionNumber: $highestSessionNumber)';
        } else {
          userLatestSession[userId] = 'Geen sensorgegevens gevonden';
        }
      }
      // Print de map buiten de loop om de volledige map te zien
      print('Laatste sessienummers per gebruiker: $userLatestSession');

      return userLatestSession;
    } catch (e) {
      print('Fout bij het ophalen van sensorgegevens: $e');
      throw e;
    }
  }
}
