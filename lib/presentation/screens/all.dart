import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../sql_management/model.dart';
import '../main_screen.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: FutureBuilder(
            future: sqlHelper.loadTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      sqlHelper.deleteTask(snapshot.data![index]['id']);
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      width: double.infinity,
                      height: 100,
                      child: Row(
                        children: [
                          Checkbox(
                            value: snapshot.data![index]['isCompleted'] == 1,
                            onChanged: (val) {
                              int newValue = val! ? 1 : 0;
                              sqlHelper
                                  .updateIsCompleted(
                                    snapshot.data![index]['id'],
                                    newValue,
                                  )
                                  .whenComplete(() {
                                    setState(() {});
                                  });
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index]['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration:
                                          snapshot.data![index]['isCompleted'] ==
                                                  1
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                  Container(
                                    height: 45,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        snapshot.data![index]['desc'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration:
                                              snapshot.data![index]['isCompleted'] ==
                                                      1
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(snapshot.data![index]['time']),
                              Text(snapshot.data![index]['day']),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  sqlHelper.deleteTask(
                                    snapshot.data![index]['id'],
                                  );
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete_forever),
                              ),
                              IconButton(
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) {
                                      TextEditingController titleController =
                                          TextEditingController(
                                            text:
                                                snapshot.data![index]['title'],
                                          );
                                      TextEditingController descController =
                                          TextEditingController(
                                            text: snapshot.data![index]['desc'],
                                          );
                                      return CupertinoAlertDialog(
                                        title: Text('Edit Task'),
                                        content: Material(
                                          color: Colors.transparent,
                                          child: Column(
                                            spacing: 5,
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                child: TextFormField(
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                    hintText: 'title',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: TextFormField(
                                                  controller: descController,
                                                  decoration: InputDecoration(
                                                    hintText: 'description',
                                                  ),
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
                                            child: Text('Edit'),
                                            onPressed: () {
                                              sqlHelper
                                                  .updateTask(
                                                    Task(
                                                      titleController.text,
                                                      descController.text,
                                                      snapshot
                                                          .data![index]['id'],
                                                    ),
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
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
