import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:classroombuddy/apidata.dart/api_Helper.dart';
import 'package:classroombuddy/customs/content.dart';
import 'package:classroombuddy/customs/data.dart';
import 'package:classroombuddy/customs/user_InfoCard.dart';
import 'package:classroombuddy/Screens/splash_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? assignments;
  bool isLoading = true;
  bool isLoadingRecent = true;

  List<Map<String, String>> recentAssignment = [];
  List<Map<String, dynamic>> recentTimetable = [];

  @override
  void initState() {
    super.initState();
    fetchBatchCode();
  }

  String? batchCode;

  Future<void> fetchBatchCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return;

      final code = userDoc.data()?['batchCode'] as String?;
      if (code == null) return;

      ApiHelper.batchID = code;

      setState(() {
        batchCode = code;
        isLoading = false;
      });

      await loadRecentData();
    } catch (e) {
      print("Error fetching batch or assignments: $e");
    }

    setState(() {
      isLoading = false;
      isLoadingRecent = false;
    });
  }

  Future<void> loadRecentData() async {
    if (batchCode == null) return;

    setState(() {
      isLoadingRecent = true;
    });

    try {
      // Fetch assignments
      final assignmentsMap = await ApiHelper.getAssignments(batchCode!) ?? {};
      recentAssignment.clear();

      if (assignmentsMap.isNotEmpty) {
        final latestAssignment =
            assignmentsMap.entries.last.value as Map<String, dynamic>;
        recentAssignment.add({
          "title": latestAssignment["title"] ?? "",
          "description": latestAssignment["description"] ?? "",
          "dueDate": latestAssignment["dueDate"] ?? "",
          "subject": latestAssignment["subject"] ?? "",
        });
      }

      // Fetch timetables
      final timetableMap = await ApiHelper.getTimetables(batchCode!) ?? {};
      recentTimetable.clear(); // use class-level variable

      if (timetableMap.isNotEmpty) {
        final latestTimetable =
            timetableMap.entries.last.value as Map<String, dynamic>;

        final subjects = (latestTimetable["subjects"] as List<dynamic>? ?? []);

        recentTimetable.add({
          "date": latestTimetable["date"] ?? "",
          "subjects": subjects.map((s) {
            final subMap = s as Map<String, dynamic>? ?? {};
            return {
              "subject": subMap["subject"] ?? "",
              "time": subMap["time"] ?? "",
              "room": subMap["room"] ?? "",
            };
          }).toList(),
        });
      }

      setState(() {
        isLoadingRecent = false;
      });
    } catch (e) {
      print("Error loading recent data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/image/hm6.gif", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          RefreshIndicator(
            onRefresh: loadRecentData,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    UserInfoCard(name: user?.displayName ?? "USER"),
                    const SizedBox(height: 15),
                    Content(batchID: batchCode, onRefresh: loadRecentData),
                    const SizedBox(height: 15),
                    isLoadingRecent
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: LinearProgressIndicator(),
                          )
                        : recentDataContainer(),
                    const SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.width * .7,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.5),
                        border: Border.all(color: Colors.white, width: .5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 65),
                  ],
                ),
              ),
            ),
          ),

          //top bar
          Positioned(
            top: 6,
            left: 12,
            right: 12,
            child: SafeArea(
              top: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 129, 129, 129).withOpacity(0.01),
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            return _roundButton(Icons.menu, () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(),
                                        ),
                                      ),
                                      DraggableScrollableSheet(
                                        initialChildSize: 0.5,
                                        minChildSize: 0.5,
                                        maxChildSize: 0.95,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ).withOpacity(0.9),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: ListView.builder(
                                              controller: scrollController,
                                              itemCount: 50,
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: const Color.fromARGB(
                                                      255,
                                                      46,
                                                      46,
                                                      46,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Text("Shibu $index"),
                                                        Text("Shibu $index"),
                                                        Text("Shibu $index"),
                                                        Text("Shibu $index"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          },
                        ),
                        Text(
                          "BATCH MATE",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'LeagueSpartan',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        _roundButton(Icons.logout, () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SplashScreen();
                              },
                            ),
                            (route) => false,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recentDataContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: (recentAssignment.isEmpty && recentTimetable.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recentAssignment.isNotEmpty) ...[
                    const Text(
                      "Latest Assignment",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 51, 51, 51)
                            .withOpacity(.7),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.white.withOpacity(.7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title: ${recentAssignment[0]["title"] ?? ""}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Subject: ${recentAssignment[0]["subject"] ?? ""}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Due: ${recentAssignment[0]["dueDate"]}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (recentTimetable.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    const Text(
                      "Latest Timetable",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 51, 51, 51)
                            .withOpacity(.7),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.white.withOpacity(.7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "📅 ${recentTimetable[0]["date"] ?? ""}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            for (var s in (recentTimetable[0]["subjects"] ?? []))
                              ...[
                                Text(
                                  "📘 Subject: ${s['subject'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "🏫 Room: ${s['room'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "⏰ Time: ${s['time'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const Divider(color: Colors.grey),
                              ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

Widget _roundButton(IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(100),
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white),
    ),
  );
}
