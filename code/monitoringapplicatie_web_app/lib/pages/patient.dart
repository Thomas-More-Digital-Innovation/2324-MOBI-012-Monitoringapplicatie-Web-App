import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:monitoringapplicatie_web_app/pages/quat_page.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  Map<String, List<String>> userSensors = {};
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Nav(),
                ],
              ),
            ),
            Column(
              children: [
                const Text(
                  'Patiënten',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Alle patiënten',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              const Divider(),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Zoeken op naam...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  setState(
                                      () {}); // Om de lijst opnieuw te bouwen wanneer de zoektekst verandert
                                },
                              ),
                              Container(
                                height: 400,
                                child: FutureBuilder<QuerySnapshot>(
                                  future: getPatienten(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    final patienten = snapshot.data!.docs;
                                    var filteredPatienten =
                                        patienten.where((patient) {
                                      String name = patient['name']
                                          .toString()
                                          .toLowerCase();
                                      String searchTerm =
                                          _searchController.text.toLowerCase();
                                      return name.contains(searchTerm);
                                    }).toList();
                                    return ListView.builder(
                                      itemCount: filteredPatienten.length,
                                      itemBuilder: (context, index) {
                                        var patient = filteredPatienten[index];
                                        return Card(
                                          child: ListTile(
                                            title: Text(
                                              patient['name'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Laatst aangemeld: ${_getLastSignedIn(patient['lastSignedIn'])}',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Text(
                                                  'Laatst data verstuurd: ${_getLastDataSend(patient['lastDataSend'])}',
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Text(
                                                    'Actief : ${patient['isSignedIn'] ? 'Ja' : 'Neen'}')
                                              ],
                                            ),
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const QuatPage(
                                                                title:
                                                                    "Quat Page")));
                                              },
                                              child:
                                                  const Text('QUAT bekijken'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
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
}
