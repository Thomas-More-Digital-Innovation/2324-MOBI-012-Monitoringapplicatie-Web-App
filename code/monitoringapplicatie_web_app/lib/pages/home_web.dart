import 'package:flutter/material.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Nav(),
            ), // Gebruik de Nav-widget hier
            Column(
              children: [
                Text(
                  'Home',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
