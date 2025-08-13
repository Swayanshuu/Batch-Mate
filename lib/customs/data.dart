import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DataApi extends StatefulWidget {
  final String? batchID;
  const DataApi({super.key, required this.batchID});

  @override
  State<DataApi> createState() => _DataApiState();
}

class _DataApiState extends State<DataApi> {
  Map<String, dynamic>? batch; // Single batch data
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
   // print("Batch ID received: ${widget.batchID}");

    getData();
  }

  void getData() async {
    final id = widget.batchID;
  //print("Debug batch ID: $id");
    if (id == null || id.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'No batch ID provided';
      });
      return;
    }

    try {
      Response response = await Dio().get(
        "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/$id.json",
      );

      if (response.data != null && response.data is Map) {
        batch = Map<String, dynamic>.from(response.data);
      } else {
        batch = null;
      }
    } catch (e) {
      errorMessage = 'Failed to load data';
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ? const Center(child: LinearProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : batch == null
          ? const Center(child: Text("Batch not found"))
          : _buildBatchDetails(),
    );
  }

  Widget _buildBatchDetails() {
    String name = batch?['name'] ?? 'No Name';

    return ListView(
      children: [
        ListTile(
          title: Text(name),
          subtitle:  Text('Batch ID: ${widget.batchID ?? 'N/A'}'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(name),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Created By: ${batch?['createdBy'] ?? 'N/A'}"),
                      const SizedBox(height: 10),
                      const Text("Timetables:"),
                      if (batch?['timetables'] != null)
                        ...batch!['timetables'].entries.map<Widget>((e) {
                          var tt = e.value;
                          return Text(
                            "${tt['date']}: ${tt['subject']} at ${tt['time']} (${tt['room']})",
                          );
                        }).toList()
                      else
                        const Text("No timetables"),
                      const SizedBox(height: 10),
                      const Text("Assignments:"),
                      if (batch?['assignments'] != null)
                        ...batch!['assignments'].entries.map<Widget>((e) {
                          var asg = e.value;
                          return Text(
                            "${asg['title']} (Due: ${asg['dueDate']})",
                          );
                        }).toList()
                      else
                        const Text("No assignments"),
                      const SizedBox(height: 10),
                      const Text("Notifications:"),
                      if (batch?['notifications'] != null &&
                          batch!['notifications'].isNotEmpty)
                        ...batch!['notifications'].entries.map<Widget>((e) {
                          var notif = e.value;
                          return Text("${notif['title']}: ${notif['message']}");
                        }).toList()
                      else
                        const Text("No notifications"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
