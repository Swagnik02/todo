// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  void addTaskToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;

    // Generate a unique ID for the document
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('task')
        .doc(user?.uid)
        .collection('myTasks')
        .doc();
    String taskID = docRef.id;
    var time = DateTime.now();

    await docRef.set({
      'taskID': taskID,
      'title': titleController.text,
      'task': taskController.text,
      'category': categoryController.text,
      'timestamp': time,
      'isChecked': false, // Add isChecked field with default value
    });

    DocumentReference catRef = FirebaseFirestore.instance
        .collection('cat')
        .doc(user?.uid)
        .collection('mycats')
        .doc();

    await catRef.set({
      'catName': categoryController.text,
      'timestamp': time,
    });

    Fluttertoast.showToast(msg: 'Task Added!!');
    Navigator.pop(context); // Close the AddTask screen after adding the task
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
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter the title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Task',
                hintText: 'Describe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Enter the category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromARGB(255, 216, 98, 255);
                      }
                      return Theme.of(context).primaryColor;
                    },
                  ),
                ),
                child: const Text('Add Task'),
                onPressed: () {
                  addTaskToFirebase();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
