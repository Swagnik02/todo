// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTask extends StatefulWidget {
  final String title;
  final String details;

  const ShowTask({Key? key, required this.title, required this.details})
      : super(key: key);

  @override
  _ShowTaskState createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  bool _isEditing = false;
  late TextEditingController _detailsController;

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
// DocumentReference docRef =

    // Push the updated task details to Firebase
    String updatedDetails = _detailsController.text;
    // Add your Firebase update logic here
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
