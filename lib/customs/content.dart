import 'dart:ui';

import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            content_Container(
              onTap: () {},
              text: "Time table",
              icon: Icons.calendar_view_day_rounded,
              rightPadding: 0,
              leftPadding: 10,
              color: Color.fromRGBO(91, 91, 91, 1), // #C0C0C0
            ),
            const SizedBox(width: 10),
            content_Container(
              onTap: () {},
              text: "Assignments",
              icon: Icons.assignment,
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
              onTap: () {},
              text: "Notices",
              icon: Icons.notifications,
              rightPadding: 0,
              leftPadding: 10,
              color: Color.fromRGBO(44, 44, 44, 1),
            ),

            const SizedBox(width: 10),

            content_Container(
              onTap: () {},
              text: "ChitChat",
              icon: Icons.chat_rounded,
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
                          Icon(icon,color: Colors.white,size: 32,),
                          SizedBox(height: 6,),
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
