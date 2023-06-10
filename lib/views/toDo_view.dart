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
  String? searchQuery = '';

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

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  Stream<QuerySnapshot>? getTaskStream() {
    CollectionReference? taskCollection = FirebaseFirestore.instance
        .collection('task')
        .doc(userId)
        .collection('myTasks');

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      // Apply search filter
      taskCollection = taskCollection.where('title',
              isGreaterThanOrEqualTo: searchQuery!.toLowerCase())
          as CollectionReference<Object?>?;
    }

    return taskCollection?.snapshots();
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getTaskStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = snapshot.data?.docs
                        .map((doc) => _TaskItem(
                              title: doc['title'],
                              task: doc['task'],
                              timestamp:
                                  (doc['timestamp'] as Timestamp).toDate(),
                              taskId: doc.id,
                              isChecked: doc['isChecked'] ?? false,
                            ))
                        .toList();
                    return ListView.builder(
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        final task = docs?[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowTask(
                                  title: task?.title ?? '',
                                  details: task?.task ?? '',
                                  taskId: task?.taskId ?? '',
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
                                        task?.title ?? '',
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
                                        DateFormat.yMd().add_jm().format(
                                            task?.timestamp ?? DateTime.now()),
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
                                      unselectedWidgetColor:
                                          Colors.purple.shade100,
                                    ),
                                    child: Checkbox(
                                      value: task?.isChecked ?? false,
                                      onChanged: (bool? newValue) async {
                                        setState(() {
                                          task?.isChecked = newValue ?? false;
                                        });

                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance
                                            .collection('task')
                                            .doc(user?.uid)
                                            .collection('myTasks')
                                            .doc(task?.taskId)
                                            .update({
                                          'isChecked': task?.isChecked,
                                        });

                                        // Show a toast message or perform any other action
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
                                          .doc(task?.taskId ??
                                              '') // Use the unique ID to delete the document
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
          ],
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

class _TaskItem {
  final String title;
  final String task;
  final DateTime timestamp;
  final String taskId;
  bool isChecked;

  _TaskItem({
    required this.title,
    required this.task,
    required this.timestamp,
    required this.taskId,
    required this.isChecked,
  });
}
