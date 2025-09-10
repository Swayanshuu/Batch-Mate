// ignore_for_file: file_names

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_text/shimmer_text.dart';

class UserGreetingCard extends StatelessWidget {
  final String name;
  UserGreetingCard({super.key, required this.name});

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
    "Smash that to-do list like a pro 🏆",
    "Don’t open the About page… unless you want to be amazed 😲",
    "Only brave souls check the Profile page 🧙‍♂️",
    "Pro tip: visiting every page may unlock easter eggs 😎",
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    final random = Random();

    final greetings = [
      {
        'start': 5,
        'end': 12,
        'messages': ["Good Morning!", "Rise and Shine!", "Morning Vibes! 🌞"],
      },
      {
        'start': 12,
        'end': 17,
        'messages': [
          "Good Afternoon!",
          "Hope you're having a great day!",
          "Hey there! ☀️",
        ],
      },
      {
        'start': 17,
        'end': 21,
        'messages': [
          "Good Evening!",
          "Evening Bliss!",
          "Hope you had a great day! 🌆",
        ],
      },
      {
        'start': 21,
        'end': 24,
        'messages': [
          "Night owls unite! 🌌",
          "The city never sleeps… and neither do you 😏",
          "Stars and vibes only ✨",
          "Late-night hustle in progress 🌃",
          "Midnight energy: full power ⚡️",
        ],
      },
      {
        'start': 0,
        'end': 5,
        'messages': ["Good Night!", "Sleep Tight! 🌌", "Late Night Vibes 🌙"],
      },
    ];

    for (var interval in greetings) {
      final start = interval['start'] as int;
      final end = interval['end'] as int;
      if (hour >= start && hour < end) {
        final msgs = interval['messages'] as List<String>;
        return msgs[random.nextInt(msgs.length)];
      }
    }

    return "Hello!";
  }

  String getRandomMessage() {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    final currentMessage = getRandomMessage(); // new random message every build

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: AutoSizeText(
                maxLines: 1,
                textAlign: TextAlign.center,
                greeting,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color.fromARGB(255, 221, 221, 221),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 10),

            Center(
              child: AutoSizeText(
                currentMessage,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
