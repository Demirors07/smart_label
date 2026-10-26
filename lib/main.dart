import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const SmartLabelApp());
}

class SmartLabelApp extends StatelessWidget {
  const SmartLabelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Label',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF247A58)),
        scaffoldBackgroundColor: const Color(0xFFF7F9F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F9F7),
          foregroundColor: Color(0xFF18352A),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
