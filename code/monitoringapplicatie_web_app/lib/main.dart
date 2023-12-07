import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monitoringapplicatie_web_app/pages/home_web.dart';
import 'package:monitoringapplicatie_web_app/pages/nav_web.dart';
import 'package:monitoringapplicatie_web_app/pages/login_web.dart';
import 'package:monitoringapplicatie_web_app/pages/patienten_web.dart';
import 'package:monitoringapplicatie_web_app/pages/web_dashboard_page.dart';
import 'package:monitoringapplicatie_web_app/pages/gebruikers_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBEWWEmntLEDFqy4taCyObSj-fiFQuzX74",
    projectId: "mobi-12",
    messagingSenderId: "281097569077",
    appId: "1:281097569077:web:e15118a28e149aa03cc27c",
  ));
  runApp(MaterialApp(
    initialRoute: '/login_web',
    routes: {
      '/web_dashboard_page': (context) => WebPage(),
      '/login_web': (context) => const LoginWeb(),
      '/home_web': (context) => const Home_page(),
      '/nav_web': (context) => const Nav(),
      '/patienten_web': (context) => const Patienten(),
      '/gebruikers_web': (context) => const Gebruikers(),
    },
  ));
}
