import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitoringapplicatie_web_app/pages/gebruikers_web.dart';
import 'package:monitoringapplicatie_web_app/pages/patienten_web.dart';
import 'package:monitoringapplicatie_web_app/pages/web_dashboard_page.dart';
import 'package:monitoringapplicatie_web_app/pages/home_web.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          //Navbar
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
                  //Met link ga je naar de home page
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
                    //Met deze link ga je naar de patienten pagina
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Patienten()),
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
                    //Met deze link ga je naar de gebruikers pagina
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Gebruikers()),
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
                // Hier voer je de actie uit die nodig is voor "Mijn Profiel"
                // Bijvoorbeeld: Navigeer naar de profielpagina
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
            SizedBox(width: 20), // Voeg wat ruimte toe tussen de knoppen
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login_web');
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed:
                          null, // Je kunt onPressed op null zetten omdat GestureDetector al de onTap verwerkt
                      tooltip:
                          'Uitloggen', // Tooltip toegevoegd voor toegankelijkheid
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
          automaticallyImplyLeading:
              false, // Dit voorkomt dat de standaard terugknop wordt weergegeven
        ));
  }
}
