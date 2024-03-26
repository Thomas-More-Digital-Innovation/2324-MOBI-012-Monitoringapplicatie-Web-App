import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({Key? key}) : super(key: key);

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  String adminEmail = "";
  String adminPassword = "";

  Future<void> updateLastLoggedIn(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sd-dummy-users')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'lastSignedIn': Timestamp.now(),
        });
      } else {
        print('Document niet gevonden voor userId: $userId');
      }
    } catch (e) {
      print("Fout bij bijwerken laatste keer aangemeld: $e");
    }
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/loginbackground.png",
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(40),
            child: Text(
              'Revapp',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Aanmelden",
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    //email text field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          adminEmail = value;
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    //Password text field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          adminPassword = value;
                        },
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: adminEmail,
                            password: adminPassword,
                          );

                          // Haal de huidige gebruiker op
                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            // Roep de functies aan om de laatste inlogtijd bij te werken en isSignedIn-status in te stellen
                            await updateLastLoggedIn(user.uid);
                            await updateIsSignedIn(user.uid, true);

                            // Navigeer naar de gewenste pagina na een succesvolle login
                            Navigator.pushReplacementNamed(
                                context, '/home_web');

                            debugPrint(
                                "Aanmelding succesvol, voer hier verdere acties uit indien nodig");
                          } else {
                            // Gebruiker is null, wat een onverwachte situatie is
                            debugPrint(
                                "Fout: Gebruiker is null na aanmelding.");
                          }
                        } catch (e) {
                          // Er is een fout opgetreden bij de aanmelding, verwerk de fout hier
                          debugPrint("Fout bij aanmelden: $e");
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 16),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Heb je nog geen login? Vraag dit dan aan bij je contactpersoon.",
                        style: TextStyle(
                            color: Colors.grey, letterSpacing: 2, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
