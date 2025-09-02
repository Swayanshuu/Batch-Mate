// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Screens/contentScreens/Notice/add_Notice.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map<String, dynamic>> notices = [];
  bool isLoading = true; // for proper loading indicator

  @override
  void initState() {
    super.initState();
    loadNotices();
  }

  Future<void> loadNotices() async {
    if (ApiHelper.batchID == null) {
      debugPrint("No batch ID found, cannot load notices.");
      return;
    }

    setState(() => isLoading = true);

    final response = await ApiHelper.getNotices(ApiHelper.batchID!);

    if (response is Map<String, dynamic>) {
      setState(() {
        notices = response.entries
            .map((entry) {
              final notice = Map<String, dynamic>.from(entry.value);
              notice["id"] = entry.key; // keep the firebase id
              return notice;
            })
            .toList()
            .reversed
            .toList();
        isLoading = false;
      });
    } else {
      debugPrint("Unexpected response: $response");
      setState(() => isLoading = false);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, "refresh");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30, right: 30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotice()),
              ).then((value) {
                if (value != null) {
                  // auto refresh when coming back
                  loadNotices();
                }
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        appBar: AppBar(
          title: const Text("Notices"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, "refresh"),
          ),
        ),
        body: isLoading
            ? LinearProgressIndicator() //  proper loader
            : notices.isEmpty
            ? const Center(child: Text("No Notice found"))
            : Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.asset("assets/image/logo.png"),
                    ),
                  ),
                  // Blur layer
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: loadNotices, //  pull to refresh
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];
                        return _buildNoticeCard(notice);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNoticeCard(Map<String, dynamic> notice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 76, 76, 76).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice['title'] ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Message: ${notice['message'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                "Created At: ${notice['createdAt'] != null ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(notice['createdAt'])) : 'N/A'}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 175, 175, 175),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Posted By: ${notice['postedBy'] ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 175, 175, 175),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
