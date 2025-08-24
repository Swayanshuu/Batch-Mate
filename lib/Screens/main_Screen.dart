// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously, unnecessary_to_list_in_spreads, file_names

import 'dart:ui';
import 'package:classroombuddy/apidata.dart/api_Helper.dart';
import 'package:classroombuddy/customs/content.dart';
import 'package:classroombuddy/customs/topbar.dart';
import 'package:classroombuddy/customs/user_InfoCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:animated_gradient_text/animated_gradient_text.dart';

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
  List<Map<String, dynamic>> recentNotice = [];

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
      await loadRecentNotice();
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

  Future<void> loadRecentNotice() async {
    if (batchCode == null) {
      return;
    }

    setState(() {
      isLoadingRecent = true;
    });

    final noticeMap = await ApiHelper.getNotices(batchCode!) ?? {};

    try {
      // Clear First
      recentNotice.clear();
      if (noticeMap.isNotEmpty) {
        // Convert to list for easy handling
        final noticeList = noticeMap.entries.toList();

        // Take last 5 notices (or fewer if less than 5 available)
        final latestNotices = noticeList
            .sublist(
              noticeList.length >= 5 ? noticeList.length - 5 : 0,
              noticeList.length,
            )
            .reversed // reverse so newest comes first
            .toList();

        for (var entry in latestNotices) {
          final data = entry.value as Map<String, dynamic>;
          recentNotice.add({
            "title": data['title'] ?? "N/A",
            "message": data['message'] ?? "No Message",
            "createdAt": data['createdAt'],
            "postedBy": data['postedBy'],
          });
        }
      }

      setState(() {
        isLoadingRecent = false;
      });
    } catch (e) {
      print("Error loading recent data: $e");
      setState(() {
        isLoadingRecent = false;
      });
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
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          RefreshIndicator(
            onRefresh: () async {
              await loadRecentData();
              await loadRecentNotice();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    UserInfoCard(name: user?.displayName ?? "USER"),
                    const SizedBox(height: 15),
                    Content(
                      batchID: batchCode,
                      onRefresh: () {
                        loadRecentData();
                        loadRecentNotice();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 15),

                    isLoadingRecent
                        ? Skeletonizer(
                            enabled: true,
                            child: Column(
                              children: [
                                recentDataContainer(),
                                const SizedBox(height: 15),
                                recentNoticeContainer(),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              recentDataContainer(),
                              const SizedBox(height: 5),
                              recentNoticeContainer(),
                            ],
                          ),

                    const SizedBox(height: 65),
                  ],
                ),
              ),
            ),
          ),

          //top bar
          TopBar(),
        ],
      ),
    );
  }

  Widget recentDataContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 70, 70, 70).withOpacity(.4),
        border: Border.all(
          color: const Color.fromARGB(255, 154, 154, 154),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: (recentAssignment.isEmpty && recentTimetable.isEmpty)
          ? const Column(
              children: [
                Text("Looks like thers is nothing added!"),
                Text("Add Assignments and Timetables!!!"),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recentAssignment.isNotEmpty) ...[
                  const AnimatedGradientText(
                    text: "Lastest Assignment",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    colors: [
                      // Off-white
                      Color(0xFFBDBDBD), // Silver gray
                      Color(0xFF424242), // Dark gray / almost black
                      Color(0xFFBDBDBD), // Silver gray
                    ],
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
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          97,
                          97,
                          97,
                        ).withOpacity(.7),
                        width: 0.5
                      ),
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
                  const AnimatedGradientText(
                    text: "Lastest Time table",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    colors: [
                      // Off-white
                      Color(0xFFBDBDBD), // Silver gray
                      Color(0xFF424242), // Dark gray / almost black
                      Color(0xFFBDBDBD), // Silver gray
                    ],
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
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          97,
                          97,
                          97,
                        ).withOpacity(.7),
                        width: 0.5
                      ),
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
                          for (var s
                              in (recentTimetable[0]["subjects"] ?? [])) ...[
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
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget recentNoticeContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 70, 70, 70).withOpacity(.4),
        border: Border.all(
          color: const Color.fromARGB(255, 154, 154, 154),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: (recentNotice.isEmpty)
          ? const Center(child: Text("Looks like there are no notices yet!"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnimatedGradientText(
                  text: "Lastest Notice",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  colors: [
                    // Off-white
                    Color(0xFFBDBDBD), // Silver gray
                    Color(0xFF424242), // Dark gray / almost black
                    Color(0xFFBDBDBD), // Silver gray
                  ],
                ),
                const SizedBox(height: 10),

                // Loop through all recent notices
                ...recentNotice.map((notice) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        51,
                        51,
                        51,
                      ).withOpacity(.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          97,
                          97,
                          97,
                        ).withOpacity(.7),
                        width: .5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📌 Title: ${notice["title"] ?? ""}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Created At: ${notice['createdAt'] != null ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(notice['createdAt'])) : 'N/A'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 175, 175, 175),
                          ),
                        ),
                        Text(
                          "Posted By: ${notice["postedBy"] ?? ""}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
