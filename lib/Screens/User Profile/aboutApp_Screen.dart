// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:classroombuddy/Screens/User%20Profile/fullScreen_Image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreAboutAppScreen extends StatelessWidget {
  final String appName;
  final String tagline;
  final String description;
  final String link;
  final List<String> screenshots;
  final String logo;

  const MoreAboutAppScreen({
    super.key,
    required this.appName,
    required this.tagline,
    required this.description,
    required this.link,
    required this.screenshots,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          child: Icon(Icons.download, size: 30),
          onPressed: () {
            if (link.isNotEmpty) launchUrl(Uri.parse(link));
          },
        ),
      ),
      appBar: AppBar(title: Text(appName), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60, // adjust size
                backgroundColor: Colors.white.withOpacity(0.2),
                child: ClipOval(
                  child: Image.network(
                    logo,
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Tagline
            Center(
              child: AutoSizeText(
                tagline,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
      
            const SizedBox(height: 15),
            // Screenshots horizontal scroll
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: screenshots.isNotEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: screenshots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final screenshot = screenshots[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImage(
                                  screenshot: screenshot,
                                  tag: 'screenshot$index',
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'screenshot$index',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                screenshot,
                                width: 200,
                                height: 400,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("No screenshots available")),
            ),
      
            const SizedBox(height: 20),
      
            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            // Download button fixed at bottom
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 5, 212),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    if (link.isNotEmpty) launchUrl(Uri.parse(link));
                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text(
                    "Download App",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
      
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
