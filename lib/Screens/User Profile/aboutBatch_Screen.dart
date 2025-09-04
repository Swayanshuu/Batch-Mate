import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutBatch extends StatefulWidget {
  const AboutBatch({super.key});

  @override
  State<AboutBatch> createState() => _AboutBatchState();
}

class _AboutBatchState extends State<AboutBatch> {
  @override
  Widget build(BuildContext context) {
    // get batchID & batch CreatedBy
    var userProvider = Provider.of<UserProvider>(context);

    String batchID = userProvider.userUID;

    final batchName = ApiHelper.batchName(batchID);
    final batchCreatedBy = ApiHelper.batchCreatedBy(batchID);

    return Scaffold(
      body: Stack(
        children: [
          // bg image

          // blur effect
          SafeArea(
            child: Column(
              children: [
                Text("Your Batch Details"),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey, Colors.black],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(batchID),
                        Text(batchName.toString()),
                        Text(batchCreatedBy.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
