import 'dart:ui';
import 'package:classroombuddy/Screens/login_Screen.dart';
import 'package:classroombuddy/apidata.dart/api_Helper.dart';
import 'package:classroombuddy/customs/content.dart';
import 'package:classroombuddy/customs/data.dart';
import 'package:classroombuddy/customs/user_InfoCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  List<Map<String, String>> recentTimetable = [];

  @override
  void initState() {
    super.initState();
    fetchBatchCode();
  }

  String? batchCode;

  // to get the batch code from user fire store cloud
  Future<void> fetchBatchCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return;

      // to get user batchid from firestore
      final code = userDoc.data()?['batchCode'] as String?;
      if (code == null) return;

      ApiHelper.batchID =
          code; // sethe batchId of apihelper to code as it is a global variable

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
        isLoadingRecent = false; // stop showing spinner
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
      // Clear previous
      recentAssignment = [];
      if (assignmentsMap.isNotEmpty) {
        // Get the last entry (latest added)
        final latestAssignment =
            // get my assignment data first
            // .entries = geu all my entries like a1, a2
            // .last = my lastest entry like a3
            // .value = extract the valu in that entry like title dueDate
            // Casts it explicitly to a Map<String, dynamic> so Dart knows the type.
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
      recentTimetable = [];
      if (timetableMap.isNotEmpty) {
        final latestTimetable =
            timetableMap.entries.last.value as Map<String, dynamic>;
        recentTimetable.add({
          "subject": latestTimetable["subject"] ?? "",
          "date": latestTimetable["date"] ?? "",
          "time": latestTimetable["time"] ?? "",
          "room": latestTimetable["room"] ?? "",
        });
      }

      isLoadingRecent = false;

      setState(() {}); // Refresh UI
    } catch (e) {
      print("Error loading recent data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Scrollable main content
          RefreshIndicator(
            onRefresh: loadRecentData,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // user info
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

          /// Top blur bar
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
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundButton(Icons.menu, () {}),
                        Text(
                          "App Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        _roundButton(Icons.logout, () async {
                          await FirebaseAuth.instance
                              .signOut(); // ✅ Proper sign-out
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                            (route) {
                              return false;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Bottom blur bar
          Positioned(
            bottom: 6,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: true,
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
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _roundButton(Icons.home, () {}),
                        Text(
                          "Bottom Bar",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        _roundButton(Icons.settings, () {}),
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
      //height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.grey.withOpacity(0.5),
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
                        color: const Color.fromARGB(
                          255,
                          51,
                          51,
                          51,
                        ).withOpacity(.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(.7)),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recentAssignment[0]["title"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              recentAssignment[0]['subject'] ?? "N/A",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Due: ${recentAssignment[0]["dueDate"]} \n${recentAssignment[0]["description"]?.replaceAll('\n', ' ')}",
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
                        color: const Color.fromARGB(
                          255,
                          51,
                          51,
                          51,
                        ).withOpacity(.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(.7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recentTimetable[0]["subject"] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${recentTimetable[0]["date"]} | ${recentTimetable[0]["time"]} | ${recentTimetable[0]["room"]}",
                              style: const TextStyle(color: Colors.white70),
                            ),
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
