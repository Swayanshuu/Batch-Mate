// ignore_for_file: must_be_immutable, file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_text/shimmer_text.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
   UserInfoCard({super.key, required this.name});

  String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning 🌞";
  } else if (hour >= 12 && hour < 17) {
    return "Good Afternoon ☀️";
  } else if (hour >= 17 && hour < 21) {
    return "Good Evening 🌇";
  } else {
    return "Good Night 🌙";
  }
}
final List<String> messages = [
  "Hmm! Nothings to do? Check Assignments 👻",
  "Time to chill? Or maybe check your tasks 😎",
  "Don't forget your deadlines! ⏰",
  "Bored? How about learning something new? 📚",
  "Take a break, but keep your brain active! 🧠",
  "Feeling lazy? Let's conquer that assignment! 💪",
  "Why not grab a coffee and plan your day ☕️",
  "Tasks won’t do themselves… maybe now? 😉",
  "You got this! Keep pushing forward 🚀",
  "A little progress each day adds up 🌱",
  "Assignments aren’t scary, you are! 😏",
  "Check something productive or just chill 😴",
  "Time flies… don’t let deadlines catch you! ⏳",
  "Hey! A quick review never hurts 📖",
  "Smash that task list like a pro 🏆",
];

late String currentMessage =messages[Random().nextInt(messages.length)];


  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              getGreeting(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
                color: Color.fromARGB(255, 221, 221, 221),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ShimmerText(
                    text: name,
                    textSize: 50,
                    textColor: Color.fromARGB(255, 255, 255, 255),
                    shiningColor: Color(0xFF424242),
                    textFamily: 'Sora',
                    duration: Duration(seconds: 9),
                    letterspacing: 1.4,
                  ),
                ),
              ],
            ),
            Center(child: Text(currentMessage))
          ],
        ),
      ),
    );
  }
}
