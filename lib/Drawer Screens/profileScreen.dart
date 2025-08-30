// ignore_for_file: file_names

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Drawer%20Screens/edit_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvide = Provider.of<UserProvider>(
      context,
    ); // we have to use in uder builder
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            // calling user data
            CircleAvatar(radius: 40, child: Text(userProvide.userName[0])),
            SizedBox(height: 8),
            Text(
              userProvide.userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                    "Batch: ${userProvide.userBatch}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(height: 8),
            Text(userProvide.userEmail),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[100],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
