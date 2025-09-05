import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AboutBatch extends StatefulWidget {
  final String batchID;
  const AboutBatch({super.key, required this.batchID});

  @override
  State<AboutBatch> createState() => _AboutBatchState();
}

class _AboutBatchState extends State<AboutBatch> {
  String batchName = "Loading...";
  String batchBy = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchBatchDetails();
  }

  Future<void> fetchBatchDetails() async {
    try {
      final dio = Dio();

      final nameRes = await dio.get(
        "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${widget.batchID}/name.json",
      );

      final byRes = await dio.get(
        "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${widget.batchID}/createdBy.json",
      );

      setState(() {
        batchName = nameRes.data?.toString() ?? "No Batch Found!";
        batchBy = byRes.data?.toString() ?? "Unknown";
      });
    } catch (e) {
      print("Error fetching batch details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // dark theme bg
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Batch Details",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),

              // card style
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 81, 81, 81), width: .5),
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      const Color.fromARGB(255, 57, 57, 57),
                      const Color.fromARGB(255, 0, 0, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Batch ID:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.batchID,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Batch Name:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        batchName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Created By:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        batchBy,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
