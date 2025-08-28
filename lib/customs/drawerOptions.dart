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
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .2,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userProvider.userName,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 30,
                ),
              ),
              Text(
                userProvider.userEmail,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  //fontSize: 40,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Batch: ${userProvider.userBatch}",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),

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
          child: ListTile(leading: Icon(Icons.person), title: Text("Profile")),
        ),
        ListTile(leading: Icon(Icons.ac_unit_sharp), title: Text("About")),
        ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
      ],
    );
  }
}
