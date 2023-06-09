import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Description',
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
                        return Color.fromARGB(255, 32, 132, 37);
                      }
                      return Theme.of(context).primaryColor;
                    })),
                    child: const Text(
                      'Add Task',
                      // style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            )));
  }
}
