// ignore_for_file: file_names, body_might_complete_normally_nullable

import 'dart:ui';

import 'package:classroombuddy/Provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Map<String, dynamic>? userData =
      {}; // use ? here so to know code that either it ll be a mapp or null
  var authUser = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  TextEditingController updateName = TextEditingController();
  TextEditingController updateBatch = TextEditingController();

  var editProfileForm = GlobalKey<FormState>();

  @override
  void initState() {
    updateName.text = Provider.of<UserProvider>(
      context,
      listen: false,
    ).userName;
    updateBatch.text = Provider.of<UserProvider>(
      context,
      listen: false,
    ).userBatch;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> datToUpdate = {
      "name": updateName.text,
      "batchCode": updateBatch.text,
    };
    db.collection("users").doc(authUser!.uid).update(datToUpdate);
    Provider.of<UserProvider>(context, listen: false).getDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Screen"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (editProfileForm.currentState!.validate()) {
                updateData();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),

      body: Stack(
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: editProfileForm,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name can't be empty!";
                          }
                        },
                        controller: updateName,
                        decoration: InputDecoration(
                          label: Text("Edit your name"),
                        ),
                      ),

                      SizedBox(height: 30),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Batch ID can't be empty!";
                          }
                        },
                        controller: updateBatch,
                        decoration: InputDecoration(
                          label: Text("Edit your batch"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
