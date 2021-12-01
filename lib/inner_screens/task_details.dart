import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/services/global_method.dart';
import 'package:work_in/widgets/comments_widget.dart';

class TaskDetails extends StatefulWidget {
  final String taskId;

  final String uploadedBy;

  const TaskDetails({required this.taskId, required this.uploadedBy});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  bool _isCommenting = false;
  var contentsInfo = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Constants.darkBlue);
  TextEditingController _commentTextEditingController = TextEditingController();

  String? _authorName;

  String? _authorPosition;

  String? taskDescription;

  String? taskTitle;

  bool? _isDone;

  Timestamp? postedDateTimestamp;

  Timestamp? deadLineDateTimestamp;
  String? deadLineDate;

  String? postedDate;

  String? userImageUrl;

  bool isDeadLineAvailable = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _commentTextEditingController.dispose();
    super.dispose();
  }

  void getData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          _authorName = userDoc.get('name');
          _authorPosition = userDoc.get('positionInCompany');
          userImageUrl = userDoc.get('userImageUrl');
        });
      }
      final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();
      if (taskDatabase == null) {
        return;
      } else {
        setState(() {
          taskDescription = taskDatabase.get('taskDescription');
          _isDone = taskDatabase.get('isDone');
          deadLineDate = taskDatabase.get('deadLineDate');
          deadLineDateTimestamp = taskDatabase.get('deadLineDateTimeStamp');
          postedDateTimestamp = taskDatabase.get('createdAt');
          var postDate = postedDateTimestamp!.toDate();
          postedDate = '${postDate.year}- ${postDate.month}-${postDate.day}';
          var date = deadLineDateTimestamp!.toDate();
          isDeadLineAvailable = date.isAfter(DateTime.now());
        });
      }
    } catch (error) {
      GlobalMethod.showErrorDialog(
          context: context, error: 'An error occurred');
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextStyle(
                color: Constants.darkBlue,
                fontStyle: FontStyle.italic,
                fontSize: 20.0),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Text(
                'Fetching data',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      taskTitle == null ? '' : taskTitle!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Constants.darkBlue),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Uploaded by ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Constants.darkBlue),
                              ),
                              const Spacer(),
                              Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3, color: Colors.pink.shade800),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        userImageUrl == null
                                            ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                            : userImageUrl!,
                                      ),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ///'uploaded name',
                                    _authorName == null ? ' ' : _authorName!,
                                    style: contentsInfo,
                                  ),
                                  Text(
                                    ///'uploaded job',
                                    _authorPosition == null
                                        ? ' '
                                        : _authorPosition!,
                                    style: contentsInfo,
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Uploaded on :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Constants.darkBlue),
                              ),
                              Text(
                                /// 'date: 20-2-2021 ',
                                postedDate == null ? '' : postedDate!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Constants.darkBlue),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DeadLine date :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Constants.darkBlue),
                              ),
                              Text(
                                /// 'date: 20-3-2021 ',
                                deadLineDate == null ? '' : deadLineDate!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              ///  'date: 20-3-2021 ',
                              isDeadLineAvailable
                                  ? 'Still have enough time'
                                  : 'No time left',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isDeadLineAvailable
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Done state :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Constants.darkBlue),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: TextButton(
                                onPressed: () {
                                  User? user = _auth.currentUser;
                                  String _uid = user!.uid;
                                  if (_uid == widget.uploadedBy) {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(widget.taskId)
                                        .update({'isDone': true});
                                    getData();
                                  } else {
                                    GlobalMethod.showErrorDialog(
                                        context: context,
                                        error:
                                            'You can\'t perform this action');
                                  }
                                },
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                      decoration: _isDone == true
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Constants.darkBlue),
                                ),
                              )),
                              Opacity(
                                  opacity: _isDone == true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  )),
                              const SizedBox(
                                width: 40.0,
                              ),
                              Flexible(
                                  child: TextButton(
                                onPressed: () {
                                  User? user = _auth.currentUser;
                                  String _uid = user!.uid;
                                  if (_uid == widget.uploadedBy) {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(widget.taskId)
                                        .update({'isDone': false});
                                    getData();
                                  } else {
                                    GlobalMethod.showErrorDialog(
                                        context: context,
                                        error:
                                            'You can\'t perform this action');
                                  }
                                },
                                child: Text(
                                  'Not done',
                                  style: TextStyle(
                                      decoration: _isDone == false
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Constants.darkBlue),
                                ),
                              )),
                              Opacity(
                                opacity: _isDone == false ? 1 : 0,
                                child: const Icon(
                                  Icons.check_box,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Task description :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Constants.darkBlue),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            ///'Task description',
                            taskDescription == null ? '' : taskDescription!,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Constants.darkBlue),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _isCommenting
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          maxLength: 200,
                                          controller:
                                              _commentTextEditingController,
                                          style: TextStyle(
                                            color: Constants.darkBlue,
                                          ),
                                          keyboardType: TextInputType.text,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.pink)),
                                          ),
                                        ),
                                        flex: 3,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                MaterialButton(
                                                  onPressed: () async {
                                                    if (_commentTextEditingController
                                                            .text.length <
                                                        7) {
                                                      GlobalMethod.showErrorDialog(
                                                          context: context,
                                                          error:
                                                              'Comment can\'t be less than 7 characters');
                                                    } else {
                                                      final _generatId =
                                                          Uuid().v4();
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('tasks')
                                                          .doc(widget.taskId)
                                                          .update({
                                                        'taskComments':
                                                            FieldValue
                                                                .arrayUnion([
                                                          {
                                                            'userId': widget
                                                                .uploadedBy,
                                                            'commentId':
                                                                _generatId,
                                                            'name': _authorName,
                                                            'commentBody':
                                                                _commentTextEditingController
                                                                    .text,
                                                            'time':
                                                                Timestamp.now(),
                                                            'userImageUrl':
                                                                userImageUrl,
                                                          }
                                                        ]),
                                                      });
                                                      await Fluttertoast
                                                          .showToast(
                                                              msg:
                                                                  "Task has been uploaded successfully",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              // timeInSecForIosWeb: 1,
                                                              backgroundColor:
                                                                  Colors
                                                                      .pinkAccent,
                                                              //textColor: Colors.white,
                                                              fontSize: 16.0);
                                                      _commentTextEditingController
                                                          .clear();
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                  color: Colors.pink.shade700,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      side: BorderSide.none),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    child: Text('Post',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            //fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isCommenting =
                                                            !_isCommenting;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.pink,
                                                          fontSize: 15),
                                                    )),
                                              ],
                                            ),
                                          ))
                                    ],
                                  )
                                : Center(
                                    child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                        });
                                      },
                                      color: Colors.pink.shade700,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          side: BorderSide.none),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        child: Text('Add a comment',
                                            style: TextStyle(
                                                color: Colors.white,
                                                //fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).get(),
                              builder: (_, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  ) ;
                                }else{
                                  if(snapshot.data == null){
                                    return Container() ;
                                  }
                                }
                            return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemBuilder: (_, index) {
                                return CommentWidget(
                                  commentId: snapshot.data!['taskComments'][index]['commentId'],
                                  commentBody: snapshot.data!['taskComments'][index]['commentBody'],
                                  commenterId: snapshot.data!['taskComments'][index]['userId'],
                                  commenterName: snapshot.data!['taskComments'][index]['name'],
                                  commentImageUrl: snapshot.data!['taskComments'][index]['userImageUrl'],
                                );
                              },
                              separatorBuilder: (_, index) {
                                return const Divider(
                                  thickness: 1,
                                );
                              },
                              itemCount: snapshot.data!['taskComments'].length,
                            );
                          }),
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),
    );
  }
}

/*
*  ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return CommentWidget();
                            },
                            separatorBuilder: (_, index) {
                              return const Divider(
                                thickness: 1,
                              );
                            },
                            itemCount: 20,
                          ),

* */
