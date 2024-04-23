import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

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

class Profiel extends StatefulWidget {
  @override
  State<Profiel> createState() => _ProfielState();
}

class _ProfielState extends State<Profiel> {
  // Dummy user data (replace with actual data retrieval logic)
  UserData userData = UserData(
    username: "JohnDoe",
    lastLoginDate: "2024-03-26",
    emailAddress: "john.doe@example.com",
    role: "Admin",
  );

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
                        Text(
                          "E-mailadres aanpassen",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Nieuw E-mailadres",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(),
                                    TextButton(
                                      onPressed: () {
                                        // Add your onPressed callback function here
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      child: Text('Opslaan'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Bevestig E-mailadres",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          "Wachtwoord aanpassen",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "oud wachtwoord",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(),
                                    
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Nieuw wachtwoord",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Bevestig nieuw wachtwoord",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(),
                                    TextButton(
                                      onPressed: () {
                                        // Add your onPressed callback function here
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      child: Text('Opslaan'),
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