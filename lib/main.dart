import 'package:classroombuddy/firebase_options.dart';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:classroombuddy/Screens/signup_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: LoginScreen(),
    );
  }
}
