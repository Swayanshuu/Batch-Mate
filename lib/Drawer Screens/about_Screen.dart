// ignore_for_file: file_names, deprecated_member_use, unnecessary_const

import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

// Launch URL helper
Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not launch $url');
  } else {
    debugPrint('Launched $url');
  }
}

// Custom Expansion Tile
class CustomExpansionTile extends StatelessWidget {
  final String title;
  final Widget content;
  final Color titleColor;
  final Color iconColor;
  final double padding;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.content,
    this.titleColor = Colors.white,
    this.iconColor = Colors.white70,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return universalContainer(
      padding: padding,
      bgColor: Colors.transparent,
      child: ExpansionTile(
        collapsedIconColor: const Color.fromARGB(255, 4, 0, 133),
        iconColor: iconColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tilePadding: const EdgeInsets.all(4),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: content,
          ),
        ],
      ),
    );
  }
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset("assets/image/aboutBG.jpg", fit: BoxFit.cover),
          ),
          // Blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    developerInfoCard(),
                    const SizedBox(height: 20),
                    _socialLinks(),
                    const SizedBox(height: 20),
                    CustomExpansionTile(
                      title: "About Developer",
                      content: Text(
                        "17th CSE ( 2024 - 28 )\n\n"
                        "Hey 👋 I’m Swayanshu Sarthak Sadangi.\n"
                        "I’m just someone who loves playing around with tech and creating things that feel fun and useful.\n\n"
                        "Most of the time you’ll find me experimenting with new ideas, breaking stuff (unintentionally 😂), and then fixing it again.\n\n"
                        "This app is just a small part of my journey — something I made with curiosity, late-night coding, and a lot of excitement.\n"
                        "I don’t see it as “perfect,” but more like a step forward, and I’ll keep learning and improving as I go. 🚀",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomExpansionTile(
                      title: "About App",
                      content: Text(
                        "Hey 👋 welcome to Batch Mate!\n\n"
                        "This app is designed to make your student life easier by keeping all your assignments, timetables, and notices in one place.\n\n"
                        "With Batch Mate, you can:\n"
                        "• Stay on top of your classes and deadlines effortlessly.\n"
                        "• Get instant notifications when new notices or assignments are posted.\n"
                        "• Organize your day and plan ahead with the built-in timetable view.\n"
                        "• Quickly find and reference past assignments or class notes.\n\n"
                        "We believe learning should be fun, not stressful, so we’ve built this app to simplify your daily academic routine.\n\n"
                        "Our goal is to continuously improve with your feedback, adding features that help you manage your studies smarter and faster. 🚀\n\n"
                        "Thanks for being part of this journey — 'Batch Mate' is here to make your college experience smoother, one notification at a time!\n\n"
                        "🐞 Found a bug or have a suggestion? Feel free to contact us anytime — your feedback helps make Batch Mate even better! 💡",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: const Color.fromARGB(255, 78, 78, 78),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "© 2025 BatchMate. All rights reserved.",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _launchUrl("https://github.com/Swayanshuu"),
          icon: FaIcon(FontAwesomeIcons.github, size: 30),
        ),
        IconButton(
          onPressed: () => _launchUrl(
            "https://www.linkedin.com/in/swayanshu-sarthak-sadangi-b6751931a/",
          ),
          icon: FaIcon(FontAwesomeIcons.linkedin, size: 30),
        ),
        IconButton(
          onPressed: () => _launchUrl("https://instagram.com/swayan.shuuu"),
          icon: FaIcon(FontAwesomeIcons.instagram, size: 30),
        ),
        IconButton(
          onPressed: () => _launchUrl("mailto:swayanshu19@gmail.com"),
          icon: FaIcon(Icons.mail, size: 30),
        ),
      ],
    );
  }

  Widget developerInfoCard() {
    return universalContainer(
      bgColor: Colors.transparent,
      padding: 4,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  "assets/image/meAI2.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                        stops: [.2, 0.8],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 132, 132, 132),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 7.0,
                        color: Color.fromARGB(255, 58, 58, 58),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'DESIGNED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'DEVELOPED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'CRAFTED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'INVENTED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'ENGINEERED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'HACKED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'MASTERMINDED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'ORCHESTRATED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'CODED',
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'THOUGHT-UP',
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "BY",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 132, 132, 132),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Swayanshu Sarthak Sadangi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget universalContainer({
  required Widget child,
  required double padding,
  required Color bgColor,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 8,
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: child,
  );
}
