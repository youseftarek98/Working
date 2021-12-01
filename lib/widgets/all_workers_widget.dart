import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_in/inner_screens/profile.dart';

class AllWorkersWidget extends StatefulWidget {
  final String? userID;

  final String? userName;

  final String? userEmail;

  final String? positionInCompany;

  final String? phoneNumber;

  final String? userImage;

  const AllWorkersWidget(
      {required this.userID,
      required this.positionInCompany,
      required this.userImage,
      required this.userEmail,
      required this.userName,
      required this.phoneNumber});

  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  ProfileScreen(userID: '${widget.userID}',))) ;
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(width: 1))),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20.0,
              child: Image.network(
                widget.userImage == null
                    ? 'https://images.unsplash.com/photo-1550439062-609e1531270e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
                    : '${widget.userImage}',
              ),
            ),
          ),
          title: Text(
            '${widget.userName} ',
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
                '${widget.positionInCompany} / ${widget.phoneNumber}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: _mailTo,
            icon: Icon(
              Icons.mail_outline,
              size: 30,
              color: Colors.pink[800],
            ),
          )),
    );
  }

  void _mailTo() async {
    /// String email = 'yousse@gmail.com';
    print('widget.userEmail  ==${widget.userEmail}');
    var url = 'mailto:${widget.userEmail}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occurred could\'t open link ';
    }
  }
}
