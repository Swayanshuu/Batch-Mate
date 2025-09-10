// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Animation/slideAnimation.dart';
import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/contentScreens/Assignment/add_Assignment.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<Map<String, dynamic>> assignments = [];
  bool isLoading = true; // for proper loading indicator

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    if (ApiHelper.batchID == null) {
      debugPrint("No batch ID found, cannot load assignments.");
      return;
    }

    setState(() => isLoading = true);

    final response = await ApiHelper.getAssignments(ApiHelper.batchID!);

    if (response is Map<String, dynamic>) {
      setState(() {
        assignments = response.entries
            .map((entry) {
              final assignment = Map<String, dynamic>.from(entry.value);
              assignment["id"] = entry.key; // keep the firebase id
              return assignment;
            })
            .toList()
            .reversed
            .toList();
        isLoading = false;
      });
    } else {
      debugPrint("Unexpected response: $response");
      setState(() => isLoading = false);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, "refresh");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAssignment()),
              ).then((value) {
                if (value != null) {
                  // auto refresh when coming back
                  loadAssignments();
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
          title: const Text("Assignments"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, "refresh"),
          ),
        ),
        body: isLoading
            ? LinearProgressIndicator() //  proper loader
            : assignments.isEmpty
            ? const Center(child: Text("No assignments found"))
            : Stack(
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
                  RefreshIndicator(
                    onRefresh: loadAssignments,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final assignment = assignments[index];
                        return SlideFadeIn(
                          duration: Duration(milliseconds: 600),
                          child: _buildAssignmentCard(assignment),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _assignmentDetailsCard(context, assignment);
        },
        onLongPress: () {
          _onPressFun(assignment);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 76, 76, 76).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
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
                assignment['title'] ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Subject: ${assignment['subject'] ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 207, 207, 207),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Due: ${assignment['dueDate'] ?? 'N/A'}",
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
  }

  Future<void> _onPressFun(Map<String, dynamic> assignment) async {
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
        final titleController = TextEditingController(
          text: assignment['title'],
        );
        final descriptionController = TextEditingController(
          text: assignment['description'],
        );
        final subjectCotroller = TextEditingController(
          text: assignment['subject'],
        );
        final duedateController = TextEditingController(
          text: assignment['dueDate'],
        );

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
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: subjectCotroller,
                    decoration: const InputDecoration(
                      labelText: "Subject",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: duedateController,
                    decoration: const InputDecoration(
                      labelText: "Due Date",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
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
                              "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${batchId}/assignments/${assignment['id']}.json",
                              data: {
                                "title": titleController.text,
                                "message": descriptionController.text,
                                "dueDate": duedateController.text,
                                "subject": subjectCotroller.text,
                              },
                            );
                            Navigator.pop(context); // close sheet
                            loadAssignments(); // refresh list
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
                            "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${batchId}/assignments/${assignment['id']}.json",
                          );
                          Navigator.pop(context); // close sheet
                          Future.delayed(Duration(milliseconds: 1000));
                          loadAssignments(); // refresh list
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

  Future<void> _assignmentDetailsCard(
    BuildContext context,
    Map<String, dynamic> assignment,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          title: Center(
            child: Column(
              children: [
                Text(
                  assignment['title'] ?? 'Untitled',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Subject:", style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      assignment['subject'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Due Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Due Date:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assignment['dueDate'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        assignment['description'] ?? '',
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Posted By
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Posted By:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assignment['postedBy'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
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
                  style: TextStyle(color: Color.fromARGB(255, 218, 218, 218)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
