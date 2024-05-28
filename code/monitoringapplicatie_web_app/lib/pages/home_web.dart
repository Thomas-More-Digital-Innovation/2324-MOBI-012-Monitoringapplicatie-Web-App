import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:monitoringapplicatie_web_app/pages/quat_page.dart';

import 'Test_List/Patient.dart';
class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  Map<String, List<String>> userSensors = {};
  late TextEditingController _searchController;
  late String currentUser; // assuming you store current user ID or username here

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
               child: Nav(),
             ),
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
                        // collom van alle patiënten (links)
                        Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Alle uw patiënten:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                const Divider(),
                                Container(
                                  height: 312.0,
                                  child: FutureBuilder<QuerySnapshot>(
                                    future: getPatienten(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator(),);
                                      }

                                      if (snapshot.hasError) {
                                        return const Center(child: Text("Dit account heeft geen patiënten."),);
                                      }

                                      final patienten = snapshot.data!.docs;

                                      if (patienten.isEmpty) {
                                        return const Center(child: Text("Geen patiënten met data."));
                                      }

                                      return ListView.builder(
                                        itemCount: patienten.length,
                                        itemBuilder: (context, index) {
                                          var patient = patienten[index];
                                          return Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(patient['name'] ?? ""),
                                                      const SizedBox(width: 10,),
                                                      Text(_getLastDataSend(patient['lastDataSend'])),
                                                      const Row(
                                                        children: [
                                                          IconButton(onPressed: null, icon: Icon(Icons.bar_chart_outlined, color: Colors.black,), tooltip: 'view dashboard',),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },

                                  ),
                                )
                              ],
                            )
                        ),
                        // spacing
                        const SizedBox(width: 20,),
                        // collom van de laatste 4 gebruikers (rechts)
                        Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Laatste Gebruikers:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left,),
                                const Divider(),
                                Container(
                                  height: 312.0,
                                  child: FutureBuilder<QuerySnapshot>(
                                    future: getPatienten(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator(),);
                                      }
                                      
                                      if (snapshot.hasError) {
                                        return const Center(child: Text("Dit account heeft geen patiënten."),);
                                      }
                                      
                                      final patienten = snapshot.data!.docs;
                                      // Filter out patients with null lastDataSend
                                      final patientsWithLastDataSend = patienten.where((patient) => patient['lastDataSend'] != null).toList();

                                      // Sort patients based on lastDataSend timestamp
                                      patientsWithLastDataSend.sort((a, b) => (b['lastDataSend'] as Timestamp).compareTo(a['lastDataSend'] as Timestamp) ?? 0);

                                      // Take up to 4 patients, or fewer if there are fewer than 4 patients available
                                      final latestPatients = patientsWithLastDataSend.take(4).toList();

                                      if (latestPatients.isEmpty) {
                                        return const Center(child: Text("Geen gebruikers met data."));
                                      }

                                      return ListView.builder(
                                        itemCount: latestPatients.length,
                                        itemBuilder: (context, index) {
                                          var patient = latestPatients[index];
                                          return Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(patient['name'] ?? ""),
                                                      const SizedBox(width: 10,),
                                                      Text(_getLastDataSend(patient['lastDataSend'])),
                                                      const Row(
                                                        children: [
                                                          IconButton(onPressed: null, icon: Icon(Icons.bar_chart_outlined, color: Colors.black,), tooltip: 'view dashboard',),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },

                                  ),
                                )
                              ],
                            )
                        ),
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

  String _getLastDataSend(Timestamp? lastDataSend) {
    if (lastDataSend == null) {
      return 'User heeft nog geen data verstuurd';
    } else {
      DateTime lastDataSendTime = lastDataSend.toDate();
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(lastDataSendTime);
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
  }
