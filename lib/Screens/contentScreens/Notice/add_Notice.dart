import 'package:classroombuddy/components/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNotice extends StatefulWidget {
  const AddNotice({super.key});

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  void addNotice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('google_users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return;

      // to get user batchid from firestore
      final code = userDoc.data()?['batchID'];

      if (code == null) return;

      final userName = userDoc.data()?['name'] ?? "Unknown";

      Response response = await Dio().post(
        "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/$code/notifications.json",

        data: {
          "title": title.text,
          "postedBy": userName,
          "createdAt": DateTime.now().toIso8601String(),
          "message": message.text,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Assignment added ✅"),
          ),
        );
      }

      Navigator.pop(context, "refresh");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Assignment",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 20),
                          textField(
                            lebelText: "Title",
                            ValidatorMessage: "Enter Title",
                            obScureText: false,
                            Controller: title,
                          ),

                          // SizedBox(height: 20),
                          // textField(
                          //   lebelText: "Subject",
                          //   ValidatorMessage: "Enter Subject name",
                          //   obScureText: false,
                          //   Controller: postedBy,
                          // ),
                          SizedBox(height: 20),

                          // description box
                          TextFormField(
                            controller: message,
                            decoration: InputDecoration(
                              labelText: "Message", // Shows above the input

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            minLines: 3, // Minimum height for the box
                            maxLines: 10, // Grows as you type (max lines)
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter Message";
                              }
                              return null;
                            },
                            obscureText:
                                false, // Not needed, but you can leave it
                          ),

                          const SizedBox(height: 28),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                addNotice();
                                // send back to AssignmentsPage
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
            ),
          ),
        ],
      ),
    );
  }
}
