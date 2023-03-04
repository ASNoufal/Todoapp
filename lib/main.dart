import 'package:flutter/material.dart';
import 'package:todooapp/screens/letStartPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.green[100],
          useMaterial3: true),
      home: const LetStartPage(),
    );
  }
}
