// main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/formulaire_page.dart';
import 'pages/resultats_page.dart';
import 'pages/connection_test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioPredict',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/formulaire': (context) => const FormulairePage(),
        '/resultats': (context) => ResultatsPage.fromPrediction(null),
        '/test-connexion': (context) => const ConnectionTestPage(),
      },
    );
  }
}