import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_in/inner_screens/profile.dart';

class CommentWidget extends StatelessWidget {
  final String commentId;

  final String commentBody;

  final String commentImageUrl;

  final String commenterName;

  final String commenterId;

  CommentWidget({Key? key,
    required this.commenterId,
    required this.commentBody,
    required this.commentImageUrl,
    required this.commenterName,
    required this.commentId,
  }) ;

  final List<Color> _colors = [
    Colors.pink,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.blue,
    Colors.grey,
    Colors.yellow,
    Colors.blueAccent,
    Colors.cyan,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  ProfileScreen(userID: commenterId,))) ;

      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: _colors[0]),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        commentImageUrl
                      ///'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                    ),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(commenterName,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    commentBody,
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
