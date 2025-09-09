// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:classroombuddy/Animation/slideAnimation.dart';
import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:classroombuddy/Screens/contentScreens/Notice/add_Notice.dart';
import 'package:classroombuddy/Screens/Services/API%20Data%20Services/api_Service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];
                        return SlideFadeIn(
                          duration: Duration(milliseconds: 600),
                          child: _buildNoticeCard(notice),
                        );
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
        onTap: () {
          _noticeDetailsCard(context, notice);
        },
        onLongPress: () async {
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          await showMenu(
            context: context,
            position: RelativeRect.fromRect(
              Offset(200, 200) & const Size(50, 50), // position of the popup
              Offset.zero & overlay.size,
            ),
            items: [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              ),
            ],
          ).then((value) {
            if (value == 'edit') {
              final batchId = Provider.of<UserProvider>(
                context,
                listen: false,
              ).userBatch;
              // 👇 directly put the bottom sheet here
              final titleController = TextEditingController(
                text: notice['title'],
              );
              final messageController = TextEditingController(
                text: notice['message'],
              );

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: messageController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Message",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // close sheet
                              },
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await Dio().patch(
                                    "https://classroombuddy-bc928-default-rtdb.firebaseio.com/batches/${batchId}/notifications/${notice['id']}.json",
                                    data: {
                                      "title": titleController.text,
                                      "message": messageController.text,
                                    },
                                  );
                                  Navigator.pop(context); // close sheet
                                  loadNotices(); // refresh list
                                } catch (e) {
                                  debugPrint("Update error: $e");
                                }
                              },
                              child: const Text("Done"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );
            } else if (value == 'delete') {
              //_deleteNotice(notice['id']);
            }
          });
        },

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
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // add .. if text is so long.
                softWrap:
                    false, // prevent text from wrapping to the next line, keeps it single-line with ...
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

  Future<void> _noticeDetailsCard(
    BuildContext context,
    Map<String, dynamic> notice,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          title: Column(
            children: [
              Text(
                notice['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                height: 1,
                width: double.infinity,
                color: Colors.white.withOpacity(.4),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created At: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notice['createdAt'] != null
                            ? DateFormat(
                                'dd MMM yyyy, hh:mm a',
                              ).format(DateTime.parse(notice['createdAt']))
                            : 'N/A',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Posted By :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notice['postedBy'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Message: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        notice['message'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 206, 206, 206),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(color: Color.fromARGB(255, 218, 218, 218)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
