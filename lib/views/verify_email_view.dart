// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/constants/routes.dart';

import '../utilities/logout_dialogue.dart.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

//logout
enum MenuAction { logout }

class _VerifyEmailViewState extends State<VerifyEmailView> {
//changes
  late Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        navigateToToDoView();
      }
    }
  }

  void navigateToToDoView() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      toDoRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        //for logout option
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
                    value: MenuAction.logout, child: Text('Log Out'))
              ];
            },
          )
        ],
        //for logout option
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Text(
              "We've sent you an email to verify your email. Please click the link to verify your email.",
              style: GoogleFonts.roboto(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Text(
              "If you havent received an verifiaction-emails kindly press the button below !!",
              style: GoogleFonts.roboto(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 40, right: 40),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromARGB(255, 32, 132, 37);
                        }
                        return Theme.of(context).primaryColor;
                      },
                    ),
                  ),
                  child: const Text(
                    'Send email verification',
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                  },
                ),
              ),
              const SizedBox(height: 0), // Add a SizedBox with zero height
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 40, right: 40),
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 173, 229, 176);
                              }
                              return Colors
                                  .white; // Change the background color to white
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.green), // Set the text color to green
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(
                              color: Color.fromARGB(255, 32, 132, 37),
                              width: 2.0,
                            ),
                          ), // Add a green border
                        ),
                        onPressed: checkEmailVerification,
                        child: const Text('Check'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
