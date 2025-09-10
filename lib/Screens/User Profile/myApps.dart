// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:classroombuddy/Screens/User%20Profile/aboutApp_Screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyApps extends StatefulWidget {
  const MyApps({super.key});

  @override
  State<MyApps> createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> {
  List<dynamic> apps = [];
  bool isLoading = true;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchApps();
  }

  Future<void> fetchApps() async {
    try {
      final url =
          "https://raw.githubusercontent.com/Swayanshuu/Batch-Mate-Helper/refs/heads/main/apps.json"
          "?ts=${DateTime.now().millisecondsSinceEpoch}";
      //  adds a timestamp to force fresh fetch

      final response = await dio.get(
        url,
        options: Options(headers: {"Cache-Control": "no-cache"}),
      );

      if (response.statusCode == 200) {
        // response.data already parsed if JSON, but to be safe:
        final List<dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        setState(() {
          apps = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Apps"), centerTitle: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Logo background
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Image.asset("assets/image/logo.png"),
                  ),
                ),
                // Blur overlay
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(color: Colors.black.withOpacity(0.7)),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: fetchApps,
                      child: apps.isEmpty
                          ? Center(
                              child: Text(
                                "No apps available right now.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: apps
                                  .map(
                                    (app) => _customBox(
                                      logo: app['logo'],

                                      link: app['link'],
                                      appName: app['name'],
                                      tagline: app['tagline'],
                                      isAvailable: app['isAvailable'],
                                      screenshots: List<String>.from(
                                        app['screenshots'],
                                      ),
                                      description: app['description'],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _customBox({
    required String appName,
    required String tagline,
    required bool isAvailable,
    required String link,
    required List<String> screenshots,
    required String description,
    required String logo,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isAvailable) {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_clock, size: 50, color: Colors.orange),
                    const SizedBox(height: 15),
                    Text(
                      "Coming Soon!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$appName will be available soon.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Navigate to MoreAboutAppScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MoreAboutAppScreen(
                logo: logo,
                appName: appName,
                tagline: tagline,
                link: link,
                screenshots: screenshots,
                description: description,
              ),
            ),
          );
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            // Logo as faint background if available
            if (isAvailable)
              Positioned.fill(
                child: Opacity(
                  opacity: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(logo, fit: BoxFit.cover),
                  ),
                ),
              ),
            if (!isAvailable)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://raw.githubusercontent.com/Swayanshuu/Batch-Mate-Helper/refs/heads/main/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                  gradient: isAvailable
                      ? LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.9),
                            const Color.fromARGB(
                              255,
                              201,
                              2,
                              174,
                            ).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.shade400.withOpacity(0.8),
                            const Color.fromARGB(
                              255,
                              108,
                              108,
                              108,
                            ).withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      maxLines: 1,
                      tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    if (isAvailable)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MoreAboutAppScreen(
                                appName: appName,
                                logo: logo,
                                tagline: tagline,
                                link: link,
                                screenshots: screenshots,
                                description: description,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "More About App",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (isAvailable)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Use Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (!isAvailable)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
