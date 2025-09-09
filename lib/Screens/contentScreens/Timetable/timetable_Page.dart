// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Animation/slideAnimation.dart';
import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/contentScreens/Timetable/add_Timetable.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<Map<String, dynamic>>? timetables;

  bool isLoading = true; // for proper loading indicator

  @override
  void initState() {
    super.initState();
    loadTimetables();
  }

  Future<void> loadTimetables() async {
    if (ApiHelper.batchID == null) {
      debugPrint("Looks like you don’t have any batch");
      return;
    }

    setState(() => isLoading = true);

    final response = await ApiHelper.getTimetables(ApiHelper.batchID!);

    if (response is Map<String, dynamic>) {
      setState(() {
        timetables = response.entries.map((entry) {
          final timetable = Map<String, dynamic>.from(entry.value);
          timetable["id"] = entry.key; // keep the firebase id
          return timetable;
        }).toList();
        isLoading = false;
      });
    } else {
      debugPrint("Unexpected response: $response");
      setState(() => isLoading = false);
    }
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

    final timetable = timetables!.toList().reversed.toList();

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
                      itemCount: timetable.length,
                      itemBuilder: (context, index) {
                        final content = timetable[index];
                        final subjects = content['subjects'] ?? [];

                        return SlideFadeIn(
                          duration: Duration(milliseconds: 600),
                          child: _buildTimetableCard(content, subjects),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableCard(
    Map<String, dynamic> content,
    List<dynamic> subjects,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _timetableDetailsCard(context, content, subjects);
            },
          );
        },

        onLongPress: () {
          _onPressFun(content, subjects);
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
                content['date'] ?? 'No Date',
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

  Future<void> _onPressFun(
    Map<String, dynamic> content,
    List<dynamic> subjects,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    return await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Offset(200, 200) & const Size(50, 50), // position of the popup
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, size: 20),
              SizedBox(width: 8),
              Text("Delete"),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        final batchId = Provider.of<UserProvider>(
          context,
          listen: false,
        ).userBatch;
        // directly put the bottom sheet here
        final dateController = TextEditingController(text: content['date']);
        // final descriptionController = TextEditingController(
        //   text: subjects['subject'],
        // );
        // final subjectCotroller = TextEditingController(text: subjects['room']);
        // final duedateController = TextEditingController(text: subjects['time']);

        showModalBottomSheet(
          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // TextField(
                  //   controller: subjectCotroller,
                  //   decoration: const InputDecoration(
                  //     labelText: "Subject",
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 12),
                  // TextField(
                  //   controller: duedateController,
                  //   decoration: const InputDecoration(
                  //     labelText: "Due Date",
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 12),
                  // TextField(
                  //   controller: descriptionController,
                  //   maxLines: 3,
                  //   decoration: const InputDecoration(
                  //     labelText: "Description",
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // close sheet
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color.fromARGB(150, 244, 244, 244),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Dio().patch(
                              "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${batchId}/timetable/${content["id"]}.json",
                              data: {
                                "date": dateController.text,
                                // "message": descriptionController.text,
                                // "dueDate": duedateController.text,
                                // "subject": subjectCotroller.text,
                              },
                            );
                            Navigator.pop(context); // close sheet
                            loadTimetables(); // refresh list
                          } catch (e) {
                            debugPrint("Update error: $e");
                          }
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      } else if (value == 'delete') {
        final batchId = Provider.of<UserProvider>(
          context,
          listen: false,
        ).userBatch;

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 48, 48, 48),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Center(child: Text("Are you sure want to delete?")),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          Dio().delete(
                            "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${batchId}/timetable/${content['id']}.json",
                          );
                          Navigator.pop(context); // close sheet
                          Future.delayed(Duration(milliseconds: 500));
                          loadTimetables(); // refresh list
                        } catch (e) {
                          debugPrint("Delete error: $e");
                        }
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget _timetableDetailsCard(
    BuildContext context,
    Map<String, dynamic> content,
    List<dynamic> subjects,
  ) {
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
                  content['date'] ?? 'No Date',
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
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Timetable :"),
              SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var s in subjects) ...[
                        Text(
                          "📘 Subject: ${s['subject'] ?? 'N/A'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "🏫 Room: ${s['room'] ?? 'N/A'}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "⏰ Time: ${s['time'] ?? 'N/A'}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 195, 194, 194),
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.white.withOpacity(.4),
                        ),
                        SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Posted By: "),
                  SizedBox(width: 4),
                  Text(
                    content['postedBy'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              SizedBox(height: 4),

              Text(
                "Scrool to view all subjects (If any!)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ],
          ),
        ),
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
              style: TextStyle(color: Color.fromARGB(255, 218, 218, 218)),
            ),
          ),
        ),
      ],
    );
  }
}
