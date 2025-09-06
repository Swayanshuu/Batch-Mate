// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Screens/contentScreens/Timetable/add_Timetable.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, dynamic>? timetables;

  bool isLoading = true; // for proper loading indicator

  @override
  void initState() {
    super.initState();
    loadTimetables();
  }

  Future<void> loadTimetables() async {
    if (ApiHelper.batchID == null) {
      print("Looks like you dont have any batch");
      return;
    }
    setState(() => isLoading = true);

    timetables = await ApiHelper.getTimetables(ApiHelper.batchID!);
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    if (timetables == null) {
      return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTimetable()),
              ).then((value) {
                if (value != null) {
                  loadTimetables(); // auto refresh
                }
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        appBar: AppBar(title: const Text("Time Tables"), centerTitle: true),
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset("assets/image/logo.png"),
              ),
            ),
            // Blur layer
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withOpacity(0.7)),
              ),
            ),
            Column(
              children: [
                LinearProgressIndicator(),
                Spacer(),
                Text("No Time table?"),
                Spacer(),
              ],
            ),
          ],
        ),
      );
    }

    final reversedList = timetables!.values.toList().reversed.toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "refresh");
        return false; // prevent default pop
      },
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTimetable()),
              ).then((value) {
                if (value != null) {
                  loadTimetables(); // auto refresh
                }
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        appBar: AppBar(
          title: const Text("Time Tables"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, "refresh");
            },
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset("assets/image/logo.png"),
              ),
            ),
            // Blur layer
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withOpacity(0.7)),
              ),
            ),
            timetables!.isEmpty
                ? const Center(child: Text("No titmetable found"))
                : RefreshIndicator(
                    onRefresh: loadTimetables,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: reversedList.length,
                      itemBuilder: (context, index) {
                        final day = reversedList[index];
                        final subjects = day['subjects'] ?? [];

                        return _buildTimetableCard(day, subjects);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableCard(Map<String, dynamic> day, List<dynamic> subjects) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 61, 61, 61),
                title: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Date: ", style: const TextStyle(fontSize: 16)),
                          SizedBox(width: 4),
                          Text(
                            day['date'] ?? 'No Date',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white.withOpacity(.4),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var s in subjects) ...[
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
                    ],
                  ],
                ),

                actions: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 76, 76, 76).withOpacity(.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day['date'] ?? 'No Date',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // loop over subjects
              for (var s in subjects) ...[
                Text(
                  "📘 Subject: ${s['subject'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "🏫 Room: ${s['room'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  "⏰ Time: ${s['time'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Divider(color: Colors.grey),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
