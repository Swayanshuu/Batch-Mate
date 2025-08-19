import 'package:classroombuddy/components/gradientColor.dart';
import 'package:flutter/material.dart';

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
              "WELCOME",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,letterSpacing: 1.4,color: Color.fromARGB(255, 216, 209, 219)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GradientText(
                    text: name,
                    textSize: 60,
                    textFamily: 'Outfit',
                    
                    
                    
                  ),
                ),
                 
              ],
            ),
          ],
        ),
      ),
    );
  }
}