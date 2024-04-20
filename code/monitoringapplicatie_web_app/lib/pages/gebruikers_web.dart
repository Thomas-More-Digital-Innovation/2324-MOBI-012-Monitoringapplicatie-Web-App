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
  String? selectedResponsible;

  void initState() {
    super.initState();
    selectedRole = null; // or initialize it with a default value if needed
    super.initState();
    selectedResponsible = null; //initialize selectedResponsible
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
                              //0: IntrinsicColumnWidth(),
                              0: FixedColumnWidth(300),
                              1: FixedColumnWidth(270),
                              2: FixedColumnWidth(100),
                              4: FixedColumnWidth(300),
                              5: FixedColumnWidth(220),
                            },
                            defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                            children: [
                              const TableRow(
                                children: <Widget>[
                                  Expanded(flex: 2, child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Gebruikersnaam',
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
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Role', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                        textAlign: TextAlign.left,),),),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Actief", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                        textAlign: TextAlign.left,),
                                    ),),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Opgevolgd door",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        textAlign: TextAlign.left,),),
                                  ),
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
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              patient['name'].toString())),),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(_getLastSignedIn(
                                              patient['lastSignedIn']))),),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(patient['role'])),),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              patient['isSignedIn'] == true
                                                  ? "Ja"
                                                  : "Nee")),),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          (patient.data() as Map<String,
                                              dynamic>?)?.containsKey(
                                              'responsible') == true
                                              ? patient['responsible'] != null
                                              ? patient['responsible']
                                              : 'N/A'
                                              : 'N/A',
                                        ),
                                      ),
                                    ),
                                    SizedBox( // Adjust the SizedBox width as needed
                                      width: 200,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.bar_chart_outlined,
                                              color: Colors.black,
                                            ),
                                            tooltip: 'View Charts',
                                            onPressed: null,
                                          ),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.sensors_rounded,
                                              color: Colors.black,
                                            ),
                                            tooltip: 'View Sensors',
                                            onPressed: null,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.insert_link_rounded,
                                              color: Colors.black,
                                            ),
                                            tooltip: 'Link',
                                            onPressed: null,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.create_rounded,
                                              color: Colors.black,
                                            ),
                                            tooltip: 'Edit',
                                            onPressed: () {
                                              print('Edit button pressed for user: ${patient['name']}');
                                              _showEditUserDialog(context, patient);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.black),
                                            tooltip: 'Delete',
                                            onPressed: () {
                                              _deleteUser(patient['userId']); // Call the function to delete a user
                                            },
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
      ),
    );
  }

  // Function om een gebruiker te updaten
  void _showEditUserDialog(BuildContext context, DocumentSnapshot user) {
    TextEditingController nameController = TextEditingController(text: user['name']);
    TextEditingController responsibleController = TextEditingController(text: user['responsible'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(
                    user['name'],
                    style: TextStyle(fontSize: 20), // Adjust the font size as needed
                  ),
                  FutureBuilder(
                    future: getPatienten(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<DocumentSnapshot> patients = snapshot.data!.docs;
                        List<DocumentSnapshot> responsiblePatients = patients.where((patient) => patient['role'] == 'Opvolger').toList();

                        List<DropdownMenuItem<String>> dropdownItems = [];
                        dropdownItems.add(
                          DropdownMenuItem(
                            value: '', // Add an empty value option
                            child: Text('None'), // Display 'None' for users with no selectedResponsible
                          ),
                        );
                        for (var patient in responsiblePatients) {
                          dropdownItems.add(
                            DropdownMenuItem(
                              value: patient['name'], // Use the user's name as the value
                              child: Text(patient['name']),
                            ),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          value: responsibleController.text.isNotEmpty ? responsibleController.text : '', // Handle empty value
                          items: dropdownItems,
                          onChanged: (String? newValue) {
                            setState(() {
                              responsibleController.text = newValue ?? '';
                            });
                          },
                          decoration: InputDecoration(labelText: 'Selected Responsible'),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without updating
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print('Update User button pressed!');
                String userId = user.id; // Get the document ID of the user
                String newResponsible = responsibleController.text; // Get the updated responsible

                print('Updating user with ID: $userId to new responsible: $newResponsible');

                try {
                  await updateUser(userId, newResponsible);
                  print('Update successful!');
                } catch (e) {
                  print('Error updating user: $e');
                }

                Navigator.of(context).pop(); // Close the dialog after update
              },
              child: Text('Update User'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUser(String uid, String newResponsible) async {
    try {
      await FirebaseFirestore.instance.collection('sd-dummy-users').doc(uid).update({
        'responsible': newResponsible,
      });
      print('User updated successfully!');
      setState(() {});
    } catch (e) {
      print('Error updating user: $e');
      throw e; // Rethrow the error to catch it in the dialog
    }
  }

  // Function om een gebruiker te verwijderen
  void _deleteUser(String uid) {
    FirebaseFirestore.instance.collection('sd-dummy-users').doc(uid).delete()
        .then((value) {
      // gebruiker verwijderd
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User deleted successfully'),
        ),
      );
      // Reload the page
      setState(() {});
    })
        .catchError((error) {
      // An error voor als het niet lukt een gebruiker te verwijderen
      print("Failed to delete user: $error");
    });
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
        return StatefulBuilder(
          builder: (context, setState) {
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

                          List<DropdownMenuItem<String>> dropdownItems = [];
                          for (var role in roles) {
                            dropdownItems.add(
                              DropdownMenuItem(
                                value: role['name'],
                                child: Text(role['name']),
                              ),
                            );
                          }

                          return DropdownButton(
                            isExpanded: true,
                            hint: Text(selectedRole ?? 'Kies de role'),
                            value: selectedRole,
                            onChanged: (String? newSelectedRole) {
                              setState(() {
                                selectedRole = newSelectedRole;
                                // Call setState to update the UI
                                // when the role selection changes
                                // and check if it's 'Patiënt'
                                setState(() {
                                  selectedResponsible = null;
                                });
                              });
                            },
                            items: dropdownItems,
                          );
                        }
                      },
                    ),
                    // Visibility wrapped around the DropdownButton
                    Visibility(
                      visible: selectedRole == 'Patiënt',
                      child: FutureBuilder(
                        future: getPatienten(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<DocumentSnapshot> patients = snapshot.data!.docs;
                            List<DocumentSnapshot> responsiblePatients = patients
                                .where((patient) => patient['role'] == 'Opvolger')
                                .toList();

                            List<DropdownMenuItem<String>> dropdownItems = [];
                            for (var patient in responsiblePatients) {
                              dropdownItems.add(
                                DropdownMenuItem(
                                  value: patient['name'],
                                  child: Text(patient['name']),
                                ),
                              );
                            }

                            return DropdownButton(
                              isExpanded: true,
                              hint: Text(selectedResponsible ?? 'Kies de opvolger'),
                              value: selectedResponsible,
                              onChanged: (String? newSelectedResponsible) {
                                setState(() {
                                  selectedResponsible = newSelectedResponsible;
                                });
                              },
                              items: dropdownItems,
                            );
                          }
                        },
                      ),
                    ),
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
                      UserCredential userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      await FirebaseFirestore.instance
                          .collection('sd-dummy-users')
                          .doc(userCredential.user?.uid)
                          .set({
                        'userId': userCredential.user?.uid,
                        'name': nameController.text,
                        'role': selectedRole,
                        'responsible': selectedResponsible,
                        'isSignedIn': false,
                        'lastSignedIn': null,
                        'lastDataSend': null,
                      });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Gebruikers()),
                      );
                    } catch (e) {
                      print("Error during user creation: $e");
                    }
                  },
                  child: Text('Create User'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
