import 'package:flutter/material.dart';
import 'package:weathering_willow/views/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF Compact Display',
      ),
      home: const HomePage(),
    );
  }
}
