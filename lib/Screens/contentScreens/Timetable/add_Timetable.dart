import 'package:classroombuddy/components/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTimetable extends StatefulWidget {
  const AddTimetable({super.key});

  @override
  State<AddTimetable> createState() => _AddTimetableState();
}

class _AddTimetableState extends State<AddTimetable> {
  final formKey = GlobalKey<FormState>();

  TextEditingController date = TextEditingController();

  // list of subject controllers
  List<Map<String, TextEditingController>> subjects = [
    {
      "subject": TextEditingController(),
      "room": TextEditingController(),
      "time": TextEditingController(),
    },
  ];

  void addSubjectField() {
    setState(() {
      subjects.add({
        "subject": TextEditingController(),
        "room": TextEditingController(),
        "time": TextEditingController(),
      });
    });
  }

  void addTimetable() async {
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

      // convert subjects controllers to json
      List<Map<String, String>> subjectData = subjects.map((map) {
        return {
          "subject": map["subject"]!.text,
          "room": map["room"]!.text,
          "time": map["time"]!.text,
        };
      }).toList();

      Response response = await Dio().post(
        "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/$code/timetable.json",
        data: {"date": date.text, "subjects": subjectData},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Timetable added ✅")));
        Navigator.pop(context, "refresh");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text("Add Timetable", style: TextStyle(fontSize: 24)),

                  const SizedBox(height: 20),
                  textField(
                    lebelText: "Date (yyyy-mm-dd)",
                    ValidatorMessage: "Enter Date",
                    obScureText: false,
                    Controller: date,
                  ),

                  const SizedBox(height: 20),

                  // Dynamic subject fields
                  Column(
                    children: List.generate(subjects.length, (index) {
                      return Column(
                        children: [
                          textField(
                            lebelText: "Subject",
                            ValidatorMessage: "Enter subject",
                            obScureText: false,
                            Controller: subjects[index]["subject"]!,
                          ),
                          const SizedBox(height: 10),
                          textField(
                            lebelText: "Room",
                            ValidatorMessage: "Enter room",
                            obScureText: false,
                            Controller: subjects[index]["room"]!,
                          ),
                          const SizedBox(height: 10),
                          textField(
                            lebelText: "Time",
                            ValidatorMessage: "Enter time",
                            obScureText: false,
                            Controller: subjects[index]["time"]!,
                          ),
                          const Divider(
                            height: 30,
                            color: Color.fromARGB(255, 87, 87, 87),
                          ),
                        ],
                      );
                    }),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: addSubjectField,
                    child: Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text(" Add Another Subject"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addTimetable();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
