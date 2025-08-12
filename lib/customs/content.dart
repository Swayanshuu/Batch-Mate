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
              rightPadding: 0,
              leftPadding: 10,
            ),
            const SizedBox(width: 10),
            content_Container(
              onTap: () {},
              text: "Assignments",
              rightPadding: 10,
              leftPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            content_Container(
              onTap: () {},
              text: "Notices",
              rightPadding: 0,
              leftPadding: 10,
            ),
    
            const SizedBox(width: 10),
    
            content_Container(
              onTap: () {},
              text: "ChitChat",
              rightPadding: 10,
              leftPadding: 0,
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
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,

          child: Container(
            height: 70,

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 57, 57, 57).withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.6)),
            ),
            child: Center(child: Text(text)),
          ),
        ),
      ),
    );
  }
}
