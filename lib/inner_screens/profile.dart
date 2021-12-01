import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/services/global_method.dart';
import 'package:work_in/widgets/drawer_widget.dart';

import '../user_state.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({required this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var titleTextStyle = const TextStyle(
      fontSize: 22.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal);
  bool _isLoading = false;

  String phoneNumber = '';

  String email = '';

  String name = '';

  String job = '';

  String? imageUrl;

  String joinedAt = '';

  bool _isSameUser = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    _isLoading = true;
    print('uid userID =========== ${widget.userID}');
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc == null) {
        return ;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          job = userDoc.get('positionInCompany');
          imageUrl = userDoc.get('userImageUrl');
          Timestamp joinedAtTimestamp = userDoc.get('createsAt');
          var joinedDate = joinedAtTimestamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        String _uid = user!.uid;

        ///ToDo check if some user ;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
        print('_isSameUser $_isSameUser');
      }
    } catch (error) {
      GlobalMethod.showErrorDialog(context: context, error: '$error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          elevation: 0,
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
        ),
        body:_isLoading
            ? const Center(
          child: Text(
            'Fetching data',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )
            : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Center(
                  child: Stack(
                    children: [
                      Card(
                          margin: const EdgeInsets.all(30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 80.0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(name == null ? '' : name,
                                      style: titleTextStyle),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$job: Since joined $joinedAt',
                                    style: TextStyle(
                                        color: Constants.darkBlue,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text('Contact info', style: titleTextStyle),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                _socialInfo(label: 'Email', content: email),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                _socialInfo(
                                    label: 'Phone number',
                                    content: phoneNumber),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                _isSameUser
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _socialButtons(
                                              color: Colors.green,
                                              icon: Icons.message_outlined,
                                              fct: () {
                                                _openWhatsAppChat();
                                              }),
                                          _socialButtons(
                                              color: Colors.red,
                                              icon: Icons.mail_outline,
                                              fct: () {
                                                _mailTo();
                                              }),
                                          _socialButtons(
                                              color: Colors.purple,
                                              icon: Icons.call_outlined,
                                              fct: () {
                                                _callPhoneNumber();
                                              }),
                                        ],
                                      ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                _isSameUser
                                    ? Container()
                                    : const Divider(
                                        thickness: 1,
                                      ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                !_isSameUser
                                    ? Container()
                                    : Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: MaterialButton(
                                            onPressed: () async {
                                              await _auth.signOut();
                                              Navigator.canPop(context)
                                                  ? Navigator.pop(context)
                                                  : null;
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              UserState()));
                                            },
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
                                                Icon(
                                                  Icons.logout,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 14),
                                                  child: Text('Logout',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )),
                      Positioned(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 10,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    imageUrl == null
                                        ? 'https://images.unsplash.com/photo-1550439062-609e1531270e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
                                        : '$imageUrl',
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ))));
  }

  void _openWhatsAppChat() async {
    ///String phoneNumber = '9048940';
    var whatsAppUrl = 'https://wa.me/$phoneNumber?text=HelloThere';
    if (await canLaunch(whatsAppUrl)) {
      await launch(whatsAppUrl);
    } else {
      throw 'Error occurred could\'t open link ';
    }
  }

  void _mailTo() async {
    /// String email = 'yousse@gmail.com';
    var url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occurred could\'t open link ';
    }
  }

  void _callPhoneNumber() async {
    /// String phoneNumber = '01155300701';
    var phoneUrl = 'tel://$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Error occurred could\'t open link ';
    }
  }

  Widget _socialInfo({required String label, required String content}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(
                color: Constants.darkBlue,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
          ),
        )
      ],
    );
  }

  Widget _socialButtons(
      {required Color color, required IconData icon, required Function fct}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
            onPressed: () {
              fct();
            },
            icon: Icon(
              icon,
              color: color,
            )),
      ),
    );
  }
}
