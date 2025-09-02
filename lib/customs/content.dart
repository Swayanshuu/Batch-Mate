// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Screens/contentScreens/Assignment/assignment_Page.dart';
import 'package:classroombuddy/Screens/contentScreens/Notice/notice_Screen.dart';
import 'package:classroombuddy/Screens/contentScreens/Timetable/timetable_Page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Content extends StatefulWidget {
  final String? batchID;
  final VoidCallback onRefresh;
  const Content({super.key, required this.batchID, required this.onRefresh});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            content_Container(
              onTap: () {
                if (widget.batchID != null) {
                  //  Ensuring batchID is available
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TimetablePage();
                      },
                    ),
                  ).then((value) {
                    if (value == "refresh") {
                      widget.onRefresh();
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.orange,
                      content: Text(
                        "Batch ID not loaded yet! wait a second",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              text: "Time table",
              icon: FontAwesomeIcons.calendarDay,
              rightPadding: 0,
              leftPadding: 10,
              color: Color.fromRGBO(91, 91, 91, 1), // #C0C0C0
            ),
            const SizedBox(width: 10),
            content_Container(
              onTap: () {
                if (widget.batchID != null) {
                  //  Ensuring batchID is available
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AssignmentsPage();
                      },
                    ),
                  ).then((value) {
                    if (value == "refresh") {
                      widget.onRefresh();
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.orange,
                      content: Text(
                        "Batch ID not loaded yet! wait a second",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              text: "Assignments",
              icon: FontAwesomeIcons.tasks,
              rightPadding: 10,
              leftPadding: 0,
              color: Color.fromRGBO(44, 44, 44, 1),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            content_Container(
              onTap: () {
                if (widget.batchID != null) {
                  //  Ensuring batchID is available
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NoticePage();
                      },
                    ),
                  ).then((value) {
                    if (value == "refresh") {
                      widget.onRefresh();
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.orange,
                      content: Text(
                        "Batch ID not loaded yet! wait a second",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
              text: "Notices",
              icon: Icons.notifications_active,
              rightPadding: 0,
              leftPadding: 10,
              color: Color.fromRGBO(44, 44, 44, 1),
            ),

            const SizedBox(width: 10),

            content_Container(
              onTap: () {},
              text: "ChitChat",
              icon: FontAwesomeIcons.message,
              rightPadding: 10,
              leftPadding: 0,
              color: Color.fromRGBO(91, 91, 91, 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget content_Container({
    required String text,
    required VoidCallback onTap,
    required double rightPadding,
    required double leftPadding,
    required Color color, // container color
    required IconData icon,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Blur background effect
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ), // blur strength
                child: Container(
                  color: Colors.transparent, // Needed for blur to work
                ),
              ),

              // Actual clickable content
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3), // slightly transparent
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5), // glow effect
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),

                    child: Align(
                      alignment: Alignment
                          .centerLeft, // center vertically, align left horizontally
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // shrink Column height to content
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: Colors.white, size: 32),
                          SizedBox(height: 6),
                          Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
