import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoringapplicatie_web_app/pages/gebruikers_web.dart';
import 'package:monitoringapplicatie_web_app/pages/patienten_web.dart';
import 'package:monitoringapplicatie_web_app/pages/patient.dart';
import 'package:monitoringapplicatie_web_app/pages/home_web.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateIsSignedIn(String userId, bool value) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sd-dummy-users')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'isSignedIn': value,
        });
      } else {
        print('Document niet gevonden voor userId: $userId');
      }
    } catch (e) {
      print("Fout bij bijwerken isSignedIn: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 70, 0),
              child: Text(
                'RevAPP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home_page()),
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                  Text(
                    'Startpagina',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Patient()),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.contact_emergency,
                      color: Colors.black,
                      size: 20,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                    Text(
                      'Patiënten',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Gebruikers()),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.manage_accounts,
                      color: Colors.black,
                      size: 20,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                    Text(
                      'Gebruikers',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Actie voor "Mijn Profiel"
            },
            child: const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 20,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                Text(
                  'Mijn Profiel',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await updateIsSignedIn(
                    user.uid, false); // Update isSignedIn in Firestore
                await FirebaseAuth.instance
                    .signOut(); // Voer de uitlogactie uit
              }
              Navigator.pushNamed(
                  context, '/login_web'); // Navigeer naar de loginpagina
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: null,
                    tooltip: 'Uitloggen',
                  ),
                  Text(
                    'Uitloggen',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
    );
  }
}
