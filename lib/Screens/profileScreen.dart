import 'package:classroombuddy/Provider/userProvider.dart';
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
    var userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        CircleAvatar(
          child: Title(
            color: Colors.deepPurple,
            child: Text(userProvider.userName[0]),
          ),
        ),
      ],
    );
  }
}
