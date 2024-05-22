import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class to hold dynamic user data
class UserData {
  String username;
  String lastLoginDate;
  String emailAddress;
  String role;

  UserData({
    required this.username,
    required this.lastLoginDate,
    required this.emailAddress,
    required this.role,
  });
}
Future<UserData> getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    String userUid = user.uid;
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('sd-dummy-users');
    
    try {
      QuerySnapshot querySnapshot = await usersCollection.where('userId', isEqualTo: userUid).get();
      
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document per user
        DocumentSnapshot userDocument = querySnapshot.docs.first;
        
        String username = userDocument.get('name');
        String lastLoginDate = userDocument.get('lastSignedIn').toString();
        String role = userDocument.get('role');
        
        return UserData(
          username: username,
          lastLoginDate: lastLoginDate,
          emailAddress: user.email.toString(),
          role: role,
        );
      } else {
        // User document does not exist
        return UserData(
          username: "",
          lastLoginDate: "",
          emailAddress: "",
          role: "",
        );
      }
    } catch (error) {

      throw error;
    }
  } else {
    // Current user is null
    return UserData(
      username: "",
      lastLoginDate: "",
      emailAddress: "",
      role: "",
    );
  }
}

class Profiel extends StatefulWidget {
  @override
  
  State<Profiel> createState() => _ProfielState();
}
class _ProfielState extends State<Profiel> {
  late UserData userData;

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

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPassword);
      print("Wachtwoord succesvol gewijzigd!");

      // Toon succesbericht aan gebruiker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Wachtwoord succesvol gewijzigd!"),
        ),
      );
    } catch (e) {
      print("Fout bij wachtwoord wijzigen: $e");
      // Toon foutmelding aan gebruiker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fout bij wachtwoord wijzigen. Probeer het opnieuw."),
        ),
      );
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    String? currentPassword =
        await _showPasswordInputDialog(context, "Huidig wachtwoord");
    if (currentPassword != null) {
      try {
        final AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: currentPassword);
        await user!.reauthenticateWithCredential(credential);

        String? newPassword =
            await _showPasswordInputDialog(context, "Nieuw wachtwoord");
        if (newPassword != null) {
          await changePassword(currentPassword, newPassword);
        }
      } catch (e) {
        print("Fout bij re-authenticatie: $e");
        // Toon foutmelding aan gebruiker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Fout bij re-authenticatie. Controleer uw huidig wachtwoord."),
          ),
        );
      }
    }
  }

  Future<String?> _showPasswordInputDialog(
      BuildContext context, String title) async {
    TextEditingController _passwordController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Wachtwoord'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Annuleer
              },
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text.trim();
                Navigator.of(context).pop(password); // Geef wachtwoord terug
              },
              child: const Text('Bevestigen'),
            ),
          ],
        );
      },
    );
  }

  //change email

    Future<String?> _showEmailInputDialog(
      BuildContext context, String title) async {
    TextEditingController _emailController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(hintText: 'e-mailadres'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Annuleer
              },
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                Navigator.of(context).pop(email); // Geef wachtwoord terug
              },
              child: const Text('Bevestigen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    String? currentPassword =
        await _showPasswordInputDialog(context, "Wachtwoord");
    if (currentPassword != null) {
      try {
        final AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: currentPassword);
        await user!.reauthenticateWithCredential(credential);

        String? newEmail =
            await _showEmailInputDialog(context, "Nieuw e-mailadres");
        if (newEmail != null) {
          await user!.verifyBeforeUpdateEmail(newEmail);
        }
      } catch (e) {
        print("Fout bij re-authenticatie: $e");
        // Toon foutmelding aan gebruiker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Fout bij re-authenticatie. Controleer uw huidig wachtwoord."),
          ),
        );
      }
    }
  }
  @override
  void initState() {
    super.initState();
    userData = UserData(  // Initialize with default values
      username: "",
      lastLoginDate: "",
      emailAddress: "",
      role: "",
    );
    loadUserData();

    super.initState();
    FirebaseAuth.instance.userChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  void loadUserData() async {
    try {
      UserData fetchedUserData = await getUserData();
      setState(() {
        userData = fetchedUserData;
      });
    } catch (error) {
      debugPrint("Error loading user data: $error");
    }
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
            Row(
              children: [
                Expanded(
                  flex: 7, // This makes the column 70% wide
                  child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Profiel",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gebruikersnaam",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(userData.username), // Dynamic data
                                    Text(
                                      "Laatste Data",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(userData.lastLoginDate), // Dynamic data
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "E-mailadres",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(userData.emailAddress), // Dynamic data
                                    Text(
                                      "Rol",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(userData.role), // Dynamic data
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                    
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      
                                      textStyle:
                                          const TextStyle(fontSize: 20, color: Colors.white),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _changeEmail(context);
                                    },
                                    child: const Text(
                                      'Email wijzigen',
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                    
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      
                                      textStyle:
                                          const TextStyle(fontSize: 20, color: Colors.white),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _changePassword(context);
                                    },
                                    child: const Text(
                                      'Wachtwoord wijzigen',
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Add your onPressed callback function here
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: Text('Log uit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}