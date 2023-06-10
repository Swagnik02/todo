// ignore_for_file: avoid_unnecessary_containers

import 'dart:developer' as devtools show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/routes.dart';
import 'package:todo/utilities/cat_View.dart';

class Sidebar extends StatelessWidget {
  String? userId = '';

  final String username;
  final IconData profileIcon;
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  Sidebar({
    Key? key,
    required this.username,
    required this.profileIcon,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  void initState() {
    getUid();
  }

  getUid() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    devtools.log(userId.toString());
    Fluttertoast.showToast(msg: userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.purple,
        canvasColor: Colors.purple.shade100,
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      profileIcon,
                      size: 40,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    username,
                    style: GoogleFonts.roboto(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            const ListTile(
              title: Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.shade300),
              ),
              child: TextButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(catViewRoute);
                  // Perform actions when the button is pressed
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  foregroundColor: Colors.white, // Change the text color
                  backgroundColor: Colors.purple.shade300,
                ),
                child: const Text(
                  'Category 1',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.shade300),
              ),
              child: TextButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(cat2ViewRoute);
                  // Perform actions when the button is pressed
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  foregroundColor: Colors.white, // Change the text color
                  backgroundColor: Colors.purple.shade300,
                ),
                child: const Text(
                  'Category 2',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.purple.shade300),
              ),
              child: TextButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(cat3ViewRoute);
                  // Perform actions when the button is pressed
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  foregroundColor: Colors.white, // Change the text color
                  backgroundColor: Colors.purple.shade300,
                ),
                child: const Text(
                  'Category 3',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),

            // Container(
            //   child: StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection('cat')
            //         .doc(userId)
            //         .collection('mycats')
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Container(
            //           child: const CircularProgressIndicator(),
            //         );
            //       } else {
            //         final docs = snapshot.data?.docs;
            //         return ListView.builder(
            //           itemCount: docs?.length,
            //           itemBuilder: (context, index) {
            //             return Container(
            //               child: Column(
            //                 children: [
            //                   Text(docs![index]['catName']),
            //                 ],
            //               ),
            //             );
            //           },
            //         );
            //       }
            //     },
            //   ),
            // )

            // FloatingActionButton(
            //   onPressed: initState,
            //   child: const Icon(Icons.refresh),
            // ),
          ],
        ),
      ),
    );
  }
}
