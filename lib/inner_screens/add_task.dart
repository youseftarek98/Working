import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/services/global_method.dart';
import 'package:work_in/widgets/drawer_widget.dart';

class AddTaskScreen extends StatefulWidget {
  // const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _categoryController =
      TextEditingController(text: 'Task Category');

  TextEditingController _titelController = TextEditingController(text: '');

  TextEditingController _descriptionController =
      TextEditingController(text: '');

  TextEditingController _deadLineDateController =
      TextEditingController(text: 'Pick up a Date');
  final _formKey = GlobalKey<FormState>();
  DateTime? _picked;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timestamp? _deadLineDateTimeStamp;

  bool _isLoading = false;

  @override
  void dispose() {
    _categoryController.dispose();
    _titelController.dispose();
    _descriptionController.dispose();
    _deadLineDateController.dispose();
    super.dispose();
  }

  void uploadFct() async {
    User? user = _auth.currentUser;
    String _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (_deadLineDateController.text == 'Pick up a Date' ||
          _categoryController.text == 'Task Category') {
        GlobalMethod.showErrorDialog(
            context: context, error: 'Please pick up everything');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      final taskId = Uuid().v4();
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
          'taskId': taskId,
          'uploadedBy': _uid,
          'taskTitle': _titelController.text,
          'taskDescription': _descriptionController.text,
          'deadLineDate': _deadLineDateController.text,
          'deadLineDateTimeStamp': _deadLineDateTimeStamp,
          'taskCategory': _categoryController.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
            msg: "Task has been uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.pinkAccent,
            //textColor: Colors.white,
            fontSize: 16.0);
        //_categoryController.clear();
        _descriptionController.clear();
        _titelController.clear();
        setState(() {
          _categoryController.text = 'Task Category';
          _deadLineDateController.text = 'Pick up a Date';
        });
      } catch (error) {
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('form not valid ');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Constants.darkBlue),
        ),
        drawer: DrawerWidget(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'All field are required',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Constants.darkBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textWidget(textLabel: 'Task category'),
                            _textFormField(
                                valueKey: 'TaskCategory',
                                controller: _categoryController,
                                enabled: false,
                                fct: () {
                                  _showTaskCategoryDialog(size);
                                },
                                maxLength: 100),
                            _textWidget(textLabel: 'Task title'),
                            _textFormField(
                                valueKey: 'TaskTitle',
                                controller: _titelController,
                                enabled: true,
                                fct: () {},
                                maxLength: 100),
                            _textWidget(textLabel: 'Task Description'),
                            _textFormField(
                                valueKey: 'TextDescription',
                                controller: _descriptionController,
                                enabled: true,
                                fct: () {},
                                maxLength: 1000),
                            _textWidget(textLabel: 'Task DeadLine date'),
                            _textFormField(
                                valueKey: 'DeadLineDate',
                                controller: _deadLineDateController,
                                enabled: false,
                                fct: () {
                                  _pickedDate();
                                },
                                maxLength: 100),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : MaterialButton(
                                        onPressed: uploadFct,
                                        color: Colors.pink.shade700,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            side: BorderSide.none),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Text('Upload',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.upload_file,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )));
  }

  void _pickedDate() async {
    _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2100));
    // print('picked $_picked');
    if (_picked != null) {
      setState(() {
        _deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            _picked!.microsecondsSinceEpoch);
        _deadLineDateController.text =
            '${_picked!.year} - ${_picked!.month} - ${_picked!.day} ';
      });
    }
  }

  _textFormField(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            fct();
          },
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field is missing';
              }
              return null;
            },
            enabled: enabled,
            key: ValueKey(valueKey),
            style: TextStyle(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontStyle: FontStyle.italic),
            maxLines: valueKey == 'TextDescription' ? 3 : 1,
            maxLength: maxLength,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.white,
              )),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.red,
              )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.pink.shade800,
              )),
              // focusedErrorBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(
              //   color: Colors.red,
              // ))
            ),
          ),
        ));
  }

  _textWidget({String? textLabel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textLabel!,
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.pink.shade800,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showTaskCategoryDialog(size) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Task Category ',
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.taskCategoryList.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoryController.text =
                              Constants.taskCategoryList[index];
                        });
                        Navigator.of(context).pop(context);
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
            ],
          );
        });
  }
}
