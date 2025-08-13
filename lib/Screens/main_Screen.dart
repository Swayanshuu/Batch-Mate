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

      if (userDoc.exists) {
        // 1️ Get batchCode first
        final code = userDoc.get('batchCode') as String?;
        setState(() {
          batchCode = code;
        });

        // 2 Fetch assignments async
        if (code != null) {
          final result = await ApiHelper.getAssignments(code);
          setState(() {
            assignments = result;
            isLoading = false;
          });
        }
        
      }
    } catch (e) {
      print("Error fetching batch or assignments: $e");
    }
  }

  // void loadAssignments() async {
  //   if (batchCode != null) {
  //     assignments = await ApiHelper.getAssignments(batchCode!);
  //     setState(() {
  //       print(assignments);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Scrollable main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  // user info
                  UserInfoCard(name: user?.displayName ?? "USER"),

                  const SizedBox(height: 15),

                  Content(),

                  const SizedBox(height: 15),

                  // batchCode == null
                  //     ? const CircularProgressIndicator()
                  //     : DataApi(batchID: batchCode),

                  // DataApi(batchID: batchCode),
                  Container(
                    child: Column(
                      children: [
                        assignments == null
                            ? LinearProgressIndicator()
                            : ListView.builder(
                                itemCount: assignments!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var a = assignments!.values.toList().reversed.elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                a['title'] ?? "Untitled",
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // this shronk the column height
                                                children: [
                                                  Text(
                                                    a['description'] ??
                                                        "No Description",
                                                  ),
                                                  Text(
                                                    a['dueDate'] ??
                                                        "No due date",
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(
                                            0.1,
                                          ), // semi-transparent background
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ), // rounded corners
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                         
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                          title: Text(
                                            a['title'] ?? "Untitled",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Due: ${a['dueDate'] ?? "No due Date"}',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white70,
                                            size: 16,
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    a['title'] ?? "Untitled",
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        a['description'] ??
                                                            "No Description",
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        a['dueDate'] ??
                                                            "No due date",
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),

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
