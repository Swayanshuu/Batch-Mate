import 'dart:ui';

import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Container(height: 100, color: Colors.grey),
            ListTile(leading: Icon(Icons.person), title: Text("Profile")),
            ListTile(leading: Icon(Icons.e_mobiledata), title: Text("About")),
            ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
          ],
        );
  }
}
