// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  addTaskToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('task')
        .doc(user?.uid)
        .collection('myTasks')
        .doc(time.toString())
        .set({
      'title': titleController,
      'task': taskController,
      'time': time.toString(),
    });
    Fluttertoast.showToast(msg: 'Task Added!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter the title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      hintText: 'Describe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromARGB(255, 32, 132, 37);
                      }
                      return Theme.of(context).primaryColor;
                    })),
                    child: const Text(
                      'Add Task',
                      // style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      addTaskToFirebase();
                    },
                  ),
                )
              ],
            )));
  }
}
