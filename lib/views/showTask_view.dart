// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTask extends StatelessWidget {
  final title, details;

  const ShowTask({super.key, required this.title, required this.details});

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
              title,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              details,
              style: GoogleFonts.roboto(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
