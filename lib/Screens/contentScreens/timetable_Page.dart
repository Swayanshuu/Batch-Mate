import 'package:classroombuddy/apidata.dart/api_Helper.dart';
import 'package:flutter/material.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, dynamic>? assignments;

  @override
  void initState() {
    super.initState();
    loadTimetables();
  }

  Future<void> loadTimetables() async {
    if (ApiHelper.batchID == null) {
      print("Looks like there is no assignents");
      return;
    }

    assignments = await ApiHelper.getTimetables(ApiHelper.batchID!);
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    if (assignments == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Time Tables"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: LinearProgressIndicator(),
        ),
      );
    }

    if (assignments!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Time Tables"), centerTitle: true),
        body: const Center(child: Text("No Time Tables found")),
      );
    }

    final reversedList = assignments!.values.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tables"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, "refresh"); //  send refresh signal
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadTimetables,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          itemCount: reversedList.length,
          itemBuilder: (context, index) {
            final a = reversedList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Container(
                  //margin: const EdgeInsets.all( 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      76,
                      76,
                      76,
                    ).withOpacity(.5),
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
                        a['date'] ?? 'No Date Mentioned',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "Subject: ${a['subject'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 207, 207, 207),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Room: ${a['room'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 175, 175, 175),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Time: ${a['time'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 175, 175, 175),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
