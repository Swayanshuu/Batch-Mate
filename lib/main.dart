import 'package:classroombuddy/Screens/main_Screen.dart';
import 'package:classroombuddy/firebase_options.dart';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:classroombuddy/Screens/signup_Screen.dart';
import 'package:classroombuddy/Screens/splash_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Main background
        canvasColor: Colors.black, // Drawer, modal, etc.
        colorScheme: const ColorScheme.dark(
          // ignore: deprecated_member_use
          background: Color.fromARGB(255, 57, 57, 57),
          surface: Colors.black,
        ),
      ),
      home: SplashScreen()
    );
  }
}
