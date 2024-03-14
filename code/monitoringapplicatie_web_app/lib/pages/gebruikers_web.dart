import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoringapplicatie_web_app/pages/dashboard.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:monitoringapplicatie_web_app/pages/quat_page.dart';

class Gebruikers extends StatefulWidget {
  const Gebruikers({super.key});

  @override
  State<Gebruikers> createState() => _GebruikersState();
}

class _GebruikersState extends State<Gebruikers> {
  Map<String, List<String>> userSensors = {};
  String? selectedRole;
  void initState() {
    super.initState();
    selectedRole = null; // or initialize it with a default value if needed
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
                  'Gebruikers',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    // Show the custom dialog when the add button is pressed
                    _showAddUserDialog(context);
                  },
                  icon: const Icon(Icons.add),
                ),
                FutureBuilder(
                  future: getPatienten(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<DocumentSnapshot> patienten = snapshot.data!.docs;
                      List<Widget> patientWidgets = [];

                      for (var patient in patienten) {
                        if (patient['role'] == 'Patiënt') {
                          patientWidgets.add(InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const QuatPage(title: 'QuatPage')),
                              );
                            },
                            child: ListTile(
                              title: Text(patient['name'] +
                                  ", Role: " +
                                  patient['role']),
                              subtitle:
                                  Text('Sensors: ${userSensors[patient.id]}'),
                            ),
                          ));
                        }
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: patientWidgets,
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
    QuerySnapshot patientenSnapshot =
        await FirebaseFirestore.instance.collection('sd-dummy-users').get();
    for (QueryDocumentSnapshot patientSnapshot in patientenSnapshot.docs) {
      String patientID = patientSnapshot.id;
      print('Patient ID: $patientID');

      QuerySnapshot sensorsSnapshot = await FirebaseFirestore.instance
          .collection('sd-dummy-users/$patientID/sensors')
          .get();

      List<String> sensorIDs = [];

      for (QueryDocumentSnapshot sensorSnapshot in sensorsSnapshot.docs) {
        String sensorID = sensorSnapshot.id;
        if (sensorSnapshot.exists) {
          sensorIDs.add(sensorID);

          // Voeg hier verdere verwerking toe, indien nodig
        } else {
          print('Geen sensor data gevonden voor Sensor ID: $sensorID');
        }
      }

      userSensors[patientID] = sensorIDs;
    }

    // Print de map buiten de loop om de volledige map te zien
    print('Alle gebruikerssensoren: $userSensors');

    return patientenSnapshot;
  }

  Future<QuerySnapshot> getRoles() async {
    return await FirebaseFirestore.instance.collection('roles').get();
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                FutureBuilder(
                    future: getRoles(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<DocumentSnapshot> roles = snapshot.data!.docs;

                        // Hier maak je een lijst van DropdownMenuItem-widgets
                        List<DropdownMenuItem<String>> dropdownItems = [];
                        for (var role in roles) {
                          dropdownItems.add(
                            DropdownMenuItem(
                              value: role['name'],
                              child: Text(role['name']),
                            ),
                          );
                        }

                        // Het DropdownButton-widget met de geselecteerde waarde, de hint en de lijst van items
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return DropdownButton(
                              isExpanded: true,
                              hint: Text(selectedRole ?? 'Kies de role'),
                              value: selectedRole,
                              onChanged: (String? newSelectedRole) {
                                setState(() {
                                  selectedRole = newSelectedRole;
                                });
                              },
                              items: dropdownItems,
                            );
                          },
                        );
                      }
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Create user with email and password
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                  // Add user details to Firestore, including user ID
                  await FirebaseFirestore.instance
                      .collection('sd-dummy-users')
                      .doc(userCredential.user?.uid)
                      .set({
                    'userId': userCredential.user?.uid,
                    'name': nameController.text,
                    'role': selectedRole,
                    'isSignedIn': false,
                    'lastSignedIn': null,
                    'lastDataSend': null,
                  });

                  // Navigate to a different screen after successful user creation
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Gebruikers()),
                  );
                } catch (e) {
                  print("Error during user creation: $e");
                  // Handle error here, for example, show an error message
                }
              },
              child: Text('Create User'),
            ),
          ],
        );
      },
    );
  }
}
