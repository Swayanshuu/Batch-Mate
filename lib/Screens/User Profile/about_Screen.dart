// ignore_for_file: file_names, deprecated_member_use, unnecessary_const

import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:classroombuddy/Animation/slideAnimation.dart';
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
        collapsedIconColor: const Color.fromARGB(255, 7, 98, 218),
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
                child: SlideFadeIn(
                  beginOffset: Offset(0, 0.2),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      logo(),
                      SizedBox(height: 20),
                      developerInfoCard(),
                      const SizedBox(height: 20),
                      _socialLinks(),
                      const SizedBox(height: 20),

                      // About Developer
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

                      // About App
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
                        "© 2025 Batch Mate. All rights reserved.",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 70, child: Image.asset("assets/image/logo.png")),
          Column(
            children: [
              const Text(
                "BATCH MATE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                "Because every batch is a story.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  letterSpacing: 1.5,
                ),
              ),
            ],
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
        SizedBox(width: 20),
        IconButton(
          onPressed: () => _launchUrl(
            "https://www.linkedin.com/in/swayanshu-sarthak-sadangi-b6751931a/",
          ),
          icon: FaIcon(FontAwesomeIcons.linkedin, size: 30),
        ),
        SizedBox(width: 20),
        IconButton(
          onPressed: () => _launchUrl("https://instagram.com/swayan.shuuu"),
          icon: FaIcon(FontAwesomeIcons.instagram, size: 30),
        ),
        SizedBox(width: 20),
        IconButton(
          onPressed: () => _launchUrl("mailto:swayanshu19@gmail.com"),
          icon: FaIcon(Icons.mail, size: 30),
        ),
      ],
    );
  }

  Widget developerInfoCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 0, 22, 40),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "You discovered the mastermind behind Batch Mate! 😏",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
      child: universalContainer(
        bgColor: Colors.transparent,
        padding: 4,
        child: Stack(
          children: [
            // Background Image + Gradient
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
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.transparent,
                          ],
                          stops: [0.3, 0.7],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text Overlay
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 200, 200, 200),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black87,
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
                  SizedBox(height: 6),
                  Text(
                    "BY",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Swayanshu Sarthak Sadangi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
