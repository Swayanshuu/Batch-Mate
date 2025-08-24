import 'package:flutter/material.dart';
import 'package:shimmer_text/shimmer_text.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  const UserInfoCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2,
                color: Color.fromARGB(255, 221, 221, 221),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ShimmerText(
                    text: name,
                    textSize: 50,
                    textColor: Color.fromARGB(255, 255, 255, 255),
                    shiningColor: Color(0xFF424242),
                    textFamily: 'Sora',
                    duration: Duration(seconds: 9),
                    letterspacing: 1.4,
                  ),
                ),
              ],
            ),
            Center(child: Text("Hmm! Nothings to do?  Check Assignments 👻"))
          ],
        ),
      ),
    );
  }
}
