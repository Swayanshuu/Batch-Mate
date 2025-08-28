import 'package:flutter/material.dart';

class DreawerOptions extends StatefulWidget {
  const DreawerOptions({super.key});

  @override
  State<DreawerOptions> createState() => _DreawerOptionsState();
}

class _DreawerOptionsState extends State<DreawerOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .2,
          color: Colors.grey,
        ),
        ListTile(leading: Icon(Icons.person), title: Text("Profile")),
        ListTile(leading: Icon(Icons.ac_unit_sharp), title: Text("About")),
        ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
      ],
    );
  }
}
