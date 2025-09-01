// ignore_for_file: must_be_immutable, file_names

import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_text/shimmer_text.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  UserInfoCard({super.key, required this.name});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  final List<String> messages = [
    "Nothing to do? Peek at your Assignments page 👻",
    "Chill mode on? Or check your Tasks first 😎",
    "Deadlines won’t wait… visit the Tasks page ⏰",
    "Bored? The Learning page has surprises 📚",
    "Take a brain break… but check the Challenges page 🧠",
    "Feeling lazy? The Assignments page can motivate you 💪",
    "Grab a coffee ☕️ and explore your Schedule page",
    "Tasks aren’t gonna do themselves… maybe check Tasks now 😉",
    "You got this! The Progress page is cheering for you 🚀",
    "Tiny progress daily = giant wins 🌱",
    "Assignments aren’t scary, YOU are 😏",
    "Quick review? Visit the Notes page 📖",
    "Smash that to-do list like a pro 🏆",
    "Don’t open the About page… unless you want to be amazed 😲",
    "Shh… secrets are hidden in the Settings page 😉",
    "Only brave souls check the Profile page 🧙‍♂️",
    "Click the Rewards page… sudden surprises await ⚡️",
    "Curiosity unlocked: Challenges page might test you 🔓",
    "Pro tip: visiting every page may unlock easter eggs 😎",
    "Warning: opening the Stats page may make you proud 🚀",
  ];

  late String currentMessage = messages[Random().nextInt(messages.length)];

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
            // Center(child: Text(currentMessage)),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 14, color: Colors.white),
              child: AnimatedTextKit(
                animatedTexts: [TypewriterAnimatedText(currentMessage)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
