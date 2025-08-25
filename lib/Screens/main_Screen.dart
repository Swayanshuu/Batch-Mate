// ignore_for_file: deprecated_member_use

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
  String? batchCode;

  bool isLoadingRecent = true;

  List<Map<String, String>> recentAssignment = [];
  List<Map<String, dynamic>> recentTimetable = [];
  List<Map<String, dynamic>> recentNotice = [];

  @override
  void initState() {
    super.initState();
    fetchBatchAndData();
  }

  Future<void> fetchBatchAndData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final code = userDoc.data()?['batchCode'] as String?;
      if (code == null) return;

      ApiHelper.batchID = code;
      batchCode = code;

      // Fetch all data at once
      await fetchAllData();
    } catch (e) {
      print("Error fetching batch or assignments: $e");
      setState(() {
        isLoadingRecent = false;
      });
    }
  }

  Future<void> fetchAllData() async {
    if (batchCode == null) return;

    setState(() {
      isLoadingRecent = true;
    });

    try {
      // Load Assignments
      final assignmentsMap = await ApiHelper.getAssignments(batchCode!) ?? {};
      List<Map<String, String>> newAssignments = [];
      if (assignmentsMap.isNotEmpty) {
        final latest =
            assignmentsMap.entries.last.value as Map<String, dynamic>;
        newAssignments.add({
          "title": latest["title"] ?? "",
          "description": latest["description"] ?? "",
          "dueDate": latest["dueDate"] ?? "",
          "subject": latest["subject"] ?? "",
        });
      }

      // Load Timetable
      final timetableMap = await ApiHelper.getTimetables(batchCode!) ?? {};
      List<Map<String, dynamic>> newTimetable = [];
      if (timetableMap.isNotEmpty) {
        final latest = timetableMap.entries.last.value as Map<String, dynamic>;
        newTimetable.add({
          "date": latest["date"] ?? "",
          "subjects": (latest["subjects"] as List<dynamic>? ?? []).map((s) {
            final subMap = s as Map<String, dynamic>? ?? {};
            return {
              "subject": subMap["subject"] ?? "",
              "time": subMap["time"] ?? "",
              "room": subMap["room"] ?? "",
            };
          }).toList(),
        });
      }

      // Load Notices
      final noticeMap = await ApiHelper.getNotices(batchCode!) ?? {};
      List<Map<String, dynamic>> newNotices = [];
      if (noticeMap.isNotEmpty) {
        final latestNotices = noticeMap.entries
            .toList()
            .sublist(
              noticeMap.length >= 5 ? noticeMap.length - 5 : 0,
              noticeMap.length,
            )
            .reversed
            .toList();
        for (var entry in latestNotices) {
          final data = entry.value as Map<String, dynamic>;
          newNotices.add({
            "title": data['title'] ?? "N/A",
            "message": data['message'] ?? "No Message",
            "createdAt": data['createdAt'],
            "postedBy": data['postedBy'],
          });
        }
      }

      // Update all state at once
      setState(() {
        recentAssignment = newAssignments;
        recentTimetable = newTimetable;
        recentNotice = newNotices;
        isLoadingRecent = false;
      });
    } catch (e) {
      print("Error loading data: $e");
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
            onRefresh: fetchAllData,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // User info card
                    UserInfoCard(name: user?.displayName ?? "USER"),
                    const SizedBox(height: 15),

                    // Main content
                    Content(batchID: batchCode, onRefresh: fetchAllData),
                    const SizedBox(height: 15),

                    // Recent data & notices with skeleton
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

          // Top bar
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
                Text("Looks like there is nothing added!"),
                Text("Add Assignments and Timetables!!!"),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recentAssignment.isNotEmpty) ...[
                  const AnimatedGradientText(
                    text: "Latest Assignment",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    colors: [
                      Color(0xFFBDBDBD),
                      Color(0xFF424242),
                      Color(0xFFBDBDBD),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
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
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title: ${recentAssignment[0]["title"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Subject: ${recentAssignment[0]["subject"]}",
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
                    text: "Latest Timetable",
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    colors: [
                      Color(0xFFBDBDBD),
                      Color(0xFF424242),
                      Color(0xFFBDBDBD),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
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
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📅 ${recentTimetable[0]["date"]}",
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
                  text: "Latest Notice",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  colors: [
                    Color(0xFFBDBDBD),
                    Color(0xFF424242),
                    Color(0xFFBDBDBD),
                  ],
                ),
                const SizedBox(height: 10),
                ...recentNotice.map((notice) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
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
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📌 Title: ${notice["title"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Created At: ${notice['createdAt'] != null ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(notice['createdAt'])) : 'N/A'}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 175, 175, 175),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Posted By: ${notice["postedBy"]}",
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
