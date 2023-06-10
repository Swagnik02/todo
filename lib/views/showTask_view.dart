// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTask extends StatefulWidget {
  final String title;
  final String details;
  final String taskId; // Add the taskId property

  const ShowTask(
      {Key? key,
      required this.title,
      required this.details,
      required this.taskId})
      : super(key: key);

  @override
  _ShowTaskState createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  bool _isEditing = false;
  late TextEditingController _detailsController;
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController(text: widget.details);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    // Push the updated task details to Firebase
    String updatedDetails = _detailsController.text;
    final user = FirebaseAuth.instance.currentUser;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('task')
        .doc(user?.uid)
        .collection('myTasks')
        .doc(widget.taskId) // Use the taskId to update the specific document
        .update({
      'task': updatedDetails,
      'time': time.toString(),
      'timestamp': time,
    });
    Fluttertoast.showToast(msg: 'Task updated!!');
    _toggleEdit(); // Switch back to non-edit mode after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              widget.title,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: _isEditing
                ? TextField(
                    controller: _detailsController,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  )
                : Text(
                    widget.details,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isEditing ? _saveChanges : _toggleEdit,
        child: _isEditing ? const Icon(Icons.done) : const Icon(Icons.edit),
      ),
    );
  }
}
