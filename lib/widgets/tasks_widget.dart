import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_in/inner_screens/task_details.dart';
import 'package:work_in/services/global_method.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle;

  final String taskDescription;

  final String taskId;

  final String uploadBy;

  final bool isDone;

  const TaskWidget({
    required this.taskTitle,
    required this.taskDescription,
    required this.taskId,
    required this.uploadBy,
    required this.isDone,
  });

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskDetails(
            taskId: widget.taskId,
            uploadedBy: widget.uploadBy,
          )));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          User? user = _auth.currentUser ;
                          String _uid = user!.uid ;
                          if(_uid == widget.uploadBy){
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(widget.taskId)
                                .delete();
                            Navigator.pop(context) ;
                          }else{
                            GlobalMethod.showErrorDialog(context: context, error: 'You don\'t have access to delete this task') ;
                          }

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                  ],
                );
              });
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration:
              const BoxDecoration(border: Border(right: BorderSide(width: 1))),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20.0,

            ///https://image.flaticon.com/icons/png/128/850/850960.png
            child: Image.network(
              widget.isDone
                  ? 'https://image.flaticon.com/icons/png/128/390/390973.png'
                  : 'https://image.flaticon.com/icons/png/128/850/850960.png',
            ),
          ),
        ),
        title: Text(
          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink[800],
        ),
      ),
    );
  }
}
