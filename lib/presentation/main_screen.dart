import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/presentation/screens/all.dart';
import 'package:tasks_app/presentation/screens/completed.dart';
import 'package:tasks_app/presentation/screens/notCompleted.dart';
import 'package:tasks_app/presentation/search_screen.dart';
import 'package:tasks_app/sql_management/sql_helper.dart';
import '../sql_management/model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _NotesScreanState();
}
bool value =true ;
SqlHelper sqlHelper = SqlHelper();
List<Widget> screens=[
  All(),
  Completed(),
  NotCompleted(),
];
int index = 0 ;
class _NotesScreanState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Tasks"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return SearchScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: screens[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (_) {
              TextEditingController titleController = TextEditingController();
              TextEditingController descController = TextEditingController();
              return CupertinoAlertDialog(
                title: Text('Add Task'),
                content: Material(
                  color: Colors.transparent,
                  child: Column(
                    spacing: 5,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(hintText: 'title'),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: descController,
                          decoration: InputDecoration(hintText: 'description'),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Add'),
                    onPressed: () {
                      sqlHelper
                          .addTask(
                        Task(titleController.text, descController.text),
                      )
                          .whenComplete(() {
                        setState(() {});
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.align_horizontal_left),label: "All"),
            BottomNavigationBarItem(icon: Icon(Icons.done_all_outlined),label: "Completed"),
            BottomNavigationBarItem(icon: Icon(Icons.access_time),label: "Not Completed"),
          ],
        currentIndex: index,
        onTap: (val){
          setState(() {
            index=val ;
          });
        },
      ),
    );
  }
}
