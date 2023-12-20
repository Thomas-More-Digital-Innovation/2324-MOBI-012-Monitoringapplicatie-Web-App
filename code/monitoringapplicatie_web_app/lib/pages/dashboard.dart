import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  final String patientID;

  const Dashboard({super.key, required this.patientID});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> testGetSessions() async {
    try {
      QuerySnapshot sessionSnapshot = await getSessions();
      for (QueryDocumentSnapshot session in sessionSnapshot.docs) {}
    } catch (e) {
      print('Fout bij het ophalen van sessies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Patient ID: ${widget.patientID}'),
            ElevatedButton(
              onPressed: () {
                testGetSessions();
              },
              child: const Text('Test getSessions'),
            ),
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot> getSessions() async {
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
        .orderBy('sampleTimeFine', descending: false)
        .get();
    sessionSnapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String sampleTimeFine = data['sampleTimeFine'];
      String packetCounter = data['packetCounter'];
      String acc = data['acc'];
      String dq = data['dq'];
      String dv = data['dv'];
      String gyr = data['gyr'];
      String mag = data['mag'];
      String quat = data['quat'];

      print('acc: $acc');
      print('dq: $dq');
    });
    return sessionSnapshot;
  }
}
