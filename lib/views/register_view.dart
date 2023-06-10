// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as devtools show log;

import 'package:todo/constants/routes.dart';

import '../utilities/show_error_dialogue.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _username,
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
                labelText: 'Email Id',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 40,
                right: 40,
              ),
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
                child: Text(
                  'Register',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  final username = _username.text;
                  final email = _email.text;
                  final password = _password.text;

                  // if username field is empty
                  if (username.isEmpty) {
                    await showErrorDialogue(context, 'Enter Username');
                    return;
                  }
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    devtools.log(userCredential.toString());
                    final userLoggedIn = FirebaseAuth.instance.currentUser;
                    await userLoggedIn?.sendEmailVerification();

                    // creating database in firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user?.uid)
                        .set({
                      'username': username,
                      'email': email,
                    });

                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on FirebaseAuthException catch (e) {
                    if (email.isEmpty && password.isEmpty) {
                      await showErrorDialogue(
                        context,
                        'Enter email and password',
                      );
                    } else if (email.isEmpty) {
                      await showErrorDialogue(
                        context,
                        'Enter email',
                      );
                    } else if (password.isEmpty) {
                      await showErrorDialogue(
                        context,
                        'Enter password',
                      );
                    } else if (e.code == 'weak-password') {
                      await showErrorDialogue(
                        context,
                        'Weak Password',
                      );
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorDialogue(
                        context,
                        'Email Already In Use',
                      );
                    } else if (e.code == 'invalid-email') {
                      await showErrorDialogue(
                        context,
                        'Invalid Email Entered',
                      );
                    } else {
                      await showErrorDialogue(
                        context,
                        'Error: ${e.code}',
                      );
                      devtools.log(e.stackTrace.toString());
                    }
                  } catch (e) {
                    await showErrorDialogue(context, e.toString());
                  }
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Already registered? Login Here!'))
          ],
        ),
      ),
    );
  }
}
