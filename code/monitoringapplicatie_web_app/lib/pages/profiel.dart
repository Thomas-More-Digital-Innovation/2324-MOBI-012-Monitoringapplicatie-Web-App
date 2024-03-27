import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class Profiel extends StatefulWidget{
  @override
  State<Profiel> createState() => _ProfielState();

}
class _ProfielState extends State<Profiel>{
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
              children: <Widget>[
                Text("Profiel"),
                Row(
                  children: [
                    Column(
                      children: [
                        Text("Gebruikersnaam"),
                        Text("Effectieve gebruikersnaam moet nog dynamisch worden"),
                        Text("Laatste Data"),
                        Text("Dynamisch laatste data")
                      ],
                    ),
                    Column(
                      children: [
                        Text("E-mailadres"),
                        Text("Dynamisch email adres"),
                        Text("rol"),
                        Text("dynamisch rol")
                      ],
                    ),
                  ],
                ),
                Text("E-mailadres aanpassen"),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nieuw E-mailadres"),
                          TextField(),
                          TextButton(
                            onPressed: () {
                              // Add your onPressed callback function here
                            },
                            child: Text('Opslaan'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bevestig E-mailadres"),
                          TextField(),
                        ],
                      )
                    )
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Add your onPressed callback function here
                  },
                  child: Text('Log uit'),
                )
              ],
            )
          ]
        )
      )
    );
  }

}