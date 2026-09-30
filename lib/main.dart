import 'package:e_commerce_demo_project/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gabaritoTextTheme = GoogleFonts.gabaritoTextTheme().apply(
      bodyColor: Colors.deepOrange,
      displayColor: Colors.deepOrange,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.gabarito().fontFamily,
        textTheme: gabaritoTextTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: SplashScreen(),
    );
  }
}
