// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

// Future<void> _launchUrl(String url)async{
// final Uri uri = Uri.parse(url);
// if(!await launchUrl(uri, mode: LaunchMode.externalApplication)){
//   throw 'Could not launch $url';
// }
// }

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('❌ Could not launch $url');
  } else {
    debugPrint('✅ Launched $url');
  }
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/image/aboutBG.jpg", fit: BoxFit.cover),
          ),
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
                    aboutDeveloper(),
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
          onPressed: () {
            _launchUrl("https://github.com/Swayanshuu");
          },
          icon: FaIcon(FontAwesomeIcons.github, size: 30),
        ),
        IconButton(
          onPressed: () {
            _launchUrl("https://www.linkedin.com/in/swayanshu-sarthak-sadangi-b6751931a/");
          },
          icon: FaIcon(FontAwesomeIcons.linkedin, size: 30),
        ),
        IconButton(
          onPressed: () {
            _launchUrl("https://instagram.com/swayan.shuuu");
          },
          icon: FaIcon(FontAwesomeIcons.instagram, size: 30),
        ),
      ],
    );
  }

  Widget aboutDeveloper() {
    return universalContainer(
      padding: 0,
      bgColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          collapsedIconColor: Colors.red,
          iconColor: Colors.green,
          tilePadding: EdgeInsets.all(4),
          //backgroundColor: Colors.white.withOpacity(0.05),
          //collapsedBackgroundColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "About Developer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
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
          ],
        ),
      ),
    );
  }

  Widget developerInfoCard() {
    return universalContainer(
      bgColor: Colors.transparent,
      padding: 4,
      child: Stack(
        children: [
          // Background image + gradient inside ClipRRect
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  "assets/image/meAI.jpg",
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

          // Name text at bottom-left
          Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Developed By",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 132, 132, 132),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
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
}
