// ignore_for_file: file_names, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/routes.dart';
import 'package:todo/utilities/add_task.dart';

import '../utilities/logout_dialogue.dart.dart';

enum MenuAction { logout }

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  String? userId = '';
  String? userName = '';

  @override
  void initState() {
    getUid();
    // Fluttertoast.showToast(msg: userName.toString());
    Fluttertoast.showToast(msg: userId.toString());
    super.initState();
  }

  getUid() async {
    final user = FirebaseAuth.instance.currentUser;
    // final userName = user?.email;
    setState(() {
      userId = user?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialogue(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                )
              ];
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('task')
              .doc(userId)
              .collection('myTasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data?.docs;
              return ListView.builder(
                itemCount: docs?.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(
                                docs![index]['title'],
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              // color: Colors.white,
                            ),
                            onPressed: () async {
                              FirebaseFirestore.instance
                                  .collection('task')
                                  .doc(userId)
                                  .collection('myTasks')
                                  .doc(docs[index]['time'])
                                  .delete();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          // color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTask(),
            ),
          );
        },
      ),
    );
  }
}
