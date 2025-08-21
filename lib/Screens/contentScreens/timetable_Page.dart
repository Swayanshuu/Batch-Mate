import 'package:classroombuddy/Screens/contentScreens/add_Timetable.dart';
import 'package:classroombuddy/apidata.dart/api_Helper.dart';
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
        body: Column(
          children: [
            LinearProgressIndicator(),
            Spacer(),
            Text("No Time table?"),
            Spacer(),
          ],
        ),
      );
    }

    // if (timetables!.isEmpty) {
    //   return Scaffold(
    //     appBar: AppBar(title: const Text("Time Tables"), centerTitle: true),
    //     body: const Center(child: Text("No Time Tables found")),
    //   );
    // }

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
        body: RefreshIndicator(
          onRefresh: loadTimetables,
          child: timetables!.isEmpty
              ? const Center(child: Text("No titmetable found"))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: reversedList.length,
                  itemBuilder: (context, index) {
                    final day = reversedList[index];
                    final subjects = day['subjects'] ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            76,
                            76,
                            76,
                          ).withOpacity(.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
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
                    );
                  },
                ),
        ),
      ),
    );
  }
}
