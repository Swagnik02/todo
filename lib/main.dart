import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/constants/routes.dart';
import 'package:todo/utilities/cat2_View.dart';
import 'package:todo/utilities/cat3_View.dart';
import 'package:todo/utilities/cat_View.dart';
import 'package:todo/views/addTask_view.dart';
import 'package:todo/views/login_view.dart';
import 'package:todo/views/register_view.dart';
import 'package:todo/views/verify_email_view.dart';
import 'package:todo/views/toDo_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        toDoRoute: (context) => const ToDoView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        addTaskRoute: (context) => const AddTask(),
        homePageRoute: (context) => const HomePage(),
        catViewRoute: (context) => const CatView(),
        cat2ViewRoute: (context) => const Cat2View(),
        cat3ViewRoute: (context) => const Cat3View(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const ToDoView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
