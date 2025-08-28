// ignore_for_file: file_names

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DreawerOptions extends StatefulWidget {
  const DreawerOptions({super.key});

  @override
  State<DreawerOptions> createState() => _DreawerOptionsState();
}

class _DreawerOptionsState extends State<DreawerOptions> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // upper box
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 45, 45, 45),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          userProvider.userName.split(
                            " ",
                          )[0], // only shows the first word of the full name
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          userProvider.userEmail,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 139, 139, 139),
                            //fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Profile
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileScreen();
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit_sharp),
                  title: Text("About"),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
              ],
            ),
          ),
        ),
        // Copyright
        Text(
          "© 2025 BatchMate. All rights reserved.",
          style: TextStyle(fontSize: 12, color: Colors.white70),
          textAlign: TextAlign.end,
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
