import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class Patienten extends StatelessWidget {
  const Patienten({Key? key});

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
                  'Patiënten',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                FutureBuilder(
                  future: getPatienten(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Verwerk de patiëntengegevens hier
                      List<DocumentSnapshot> patienten = snapshot.data!.docs;
                      List<Widget> patientWidgets = [];

                      for (var patient in patienten) {
                        // Voeg de patiënt toe aan de lijst van widgets
                        patientWidgets.add(
                          ListTile(
                            title: Text(patient['name']),
                            subtitle: Text(patient['role']),
                            tileColor: Colors.grey[200],
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          ...patientWidgets,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot> getPatienten() async {
    // Hier moet je de juiste Firestore-collectie opgeven waar je patiëntengegevens hebt opgeslagen
    return await FirebaseFirestore.instance
        .collection('sd-dummy-users')
        .where('role', isEqualTo: 'Patiënt')
        .get();
  }
}
