import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/widgets/drawer_widget.dart';
import 'package:work_in/widgets/tasks_widget.dart';

///TasksScreen

class TasksScreen extends StatefulWidget {

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? taskCategory;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          leading: Builder(builder: (_) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(_).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.red,
                ));
          }),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            'Tasks',
            style: TextStyle(color: Colors.pink),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _showTaskCategoryDialog(context, size);
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  color: Colors.black,
                )),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('taskCategory', isEqualTo: taskCategory)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return TaskWidget(
                        taskTitle: snapshot.data!.docs[index]['taskTitle'],
                        taskDescription: snapshot.data!.docs[index]
                            ['taskDescription'],
                        taskId: snapshot.data!.docs[index]['taskId'],
                        uploadBy: snapshot.data!.docs[index]['uploadedBy'],
                        isDone: snapshot.data!.docs[index]['isDone'],
                      );
                    });
              } else {
                return const Center(
                  child: Text('No tasks has been uploaded'),
                );
              }
            }
            return const Center(
              child: Text('Something want wrong'),
            );
          },
        ));
  }

  void _showTaskCategoryDialog(BuildContext context, size) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Task Category ',
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.4,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.taskCategoryList.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          taskCategory = Constants.taskCategoryList[index];
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                        print(
                            ' taskCategoryList[index] ${Constants.taskCategoryList[index]}');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red[200],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.taskCategoryList[index],
                              style: const TextStyle(
                                  color: Color(0xFF00325A),
// fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    taskCategory = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel filter'),
              )
            ],
          );
        });
  }
}
