import 'package:classroombuddy/signup_Screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Main background
        canvasColor: Colors.black, // Drawer, modal, etc.
        colorScheme: const ColorScheme.dark(
          background: Color.fromARGB(255, 57, 57, 57),
          surface: Colors.black,
        ),
      ),
      home: SignupScreen(),
    );
  }
}
