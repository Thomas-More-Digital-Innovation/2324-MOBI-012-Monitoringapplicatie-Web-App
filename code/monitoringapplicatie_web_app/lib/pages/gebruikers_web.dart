import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class Gebruikers extends StatelessWidget {
  const Gebruikers({Key? key});

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
                        patientWidgets.add(
                          ListTile(
                            title: Text(patient['name']),
                            subtitle: Text(patient['role']),
                          ),
                        );
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
    return await FirebaseFirestore.instance.collection('sd-dummy-users').get();
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();

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
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: 'Role'),
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
                    'role': roleController.text,
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
