// ignore_for_file: file_names, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/routes.dart';
import 'package:todo/views/addTask_view.dart';
import 'package:todo/views/showTask_view.dart';

import '../utilities/logout_dialogue.dart.dart';

enum MenuAction { logout }

class ToDoView extends StatefulWidget {
  const ToDoView({Key? key}) : super(key: key);

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  String? userId = '';

  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async {
    final user = FirebaseAuth.instance.currentUser;
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
        color: Colors.purple.shade100,
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
                  var time = (docs?[index]['timestamp'] as Timestamp).toDate();
                  var taskId = docs?[index].id; // Unique ID of the document
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowTask(
                            title: docs?[index]['title'],
                            details: docs?[index]['task'],
                            taskId: docs?[index]['taskID'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade400,
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
                                  docs?[index]['title'],
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.purple.shade100,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  DateFormat.yMd().add_jm().format(time),
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.purple.shade100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.purple.shade100,
                              ),
                              child: Checkbox(
                                value:
                                    false, // Replace with your checkbox value
                                onChanged: (bool? newValue) {
                                  // Handle checkbox value change
                                },
                                checkColor: Colors.white,
                                activeColor: Colors.purple.shade300,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.purple.shade100,
                              ),
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection('task')
                                    .doc(userId)
                                    .collection('myTasks')
                                    .doc(
                                        taskId) // Use the unique ID to delete the document
                                    .delete();
                              },
                            ),
                          )
                        ],
                      ),
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
