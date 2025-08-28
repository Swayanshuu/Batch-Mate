// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/firebase_options.dart';
import 'package:classroombuddy/Screens/splash_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final userProvider = UserProvider();
        userProvider.getDetails(); // fetch Firestore data immediately
        return userProvider;
      },
      child: MyApp(),
    ),
  );
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
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          10,
          10,
          10,
        ), // Main background
        canvasColor: Colors.black, // Drawer, modal, etc.
        fontFamily: 'Sora',
        colorScheme: const ColorScheme.dark(
          // ignore: deprecated_member_use
          background: Colors.black,
          surface: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 21, 21, 21),
          // elevation: 0, // remove shadow if you want flat look
          // titleTextStyle: TextStyle(),
          shape: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(.5), width: 1),
          ),
        ),
      ),

      home: SplashScreen(),
    );
  }
}
