import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              padding: EdgeInsets.all(15),
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
                                      return const Center(
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
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Laatst aangemeld: ${_getLastSignedIn(patient['lastSignedIn'])}',
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  'Laatst data verstuurd: ${_getLastDataSend(patient['lastDataSend'])}',
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                    'Actief : ${patient['isSignedIn'] ? 'Ja' : 'Neen'}')
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const QuatPage(
                                                                    title:
                                                                        "Quat Page")));
                                                  },
                                                  icon: const Icon(
                                                    Icons.bar_chart_outlined,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      removeResponsible(
                                                          patient.id);
                                                      setState(
                                                          () {}); // This will trigger a rebuild of the widget
                                                    },
                                                    icon: const Icon(
                                                      Icons.link_off,
                                                      color: Colors.black,
                                                    ))
                                              ],
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

  void removeResponsible(String paientId) async {
    try {
      await FirebaseFirestore.instance
          .collection('sd-dummy-users')
          .doc(paientId)
          .update({'responsible': null});
    } catch (e) {
      print(
          'Er is een fout opgetreden bij het verwijderen van de verantwoordelijke: $e');
    }
  }
}
