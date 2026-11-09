import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "TaRa's Corner",

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFFFF8F7),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFDCCBF0),
          primary: const Color(0xFFDCCBF0),
          secondary: const Color(0xFFE8D5A8),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE6DDF5),
          foregroundColor: Color(0xFF514064),
          centerTitle: true,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDCCBF0),
            foregroundColor: const Color(0xFF514064),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDCCBF0), width: 2),
          ),
        ),
      ),

      home: const LoginPage(),
    );
  }
}
