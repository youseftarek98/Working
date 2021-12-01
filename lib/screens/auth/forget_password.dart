import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:work_in/screens/auth/sign_up.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  late TextEditingController _forgetPasswordTextEditingController =
  TextEditingController(text: '');





  @override
  void dispose() {
    _animationController.dispose();
    _forgetPasswordTextEditingController.dispose() ;
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _forgetPassword() {

   /// print('_forgetPasswordTextEditingController.text ${_forgetPasswordTextEditingController.text}') ;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.red,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
            'https://images.unsplash.com/photo-1550439062-609e1531270e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
            placeholder: (context, url) => Image.asset(
              'asset/images/XAWM0900.JPG',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  "Forget Password",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ), const SizedBox(
                  height: 10,
                ),

                const Text(
                  "Email address",
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
               Padding(padding: const EdgeInsets.all(2) ,
                 child:  TextField(
                   controller: _forgetPasswordTextEditingController,
                   decoration: InputDecoration(
                     filled: true,
                     fillColor: Colors.white,
                     enabledBorder: const UnderlineInputBorder(
                         borderSide: BorderSide(color: Colors.white)),
                     focusedBorder: UnderlineInputBorder(
                         borderSide:
                         BorderSide(color: Colors.pink.shade700)),
                   ),
                 ) ,
               ),
                const SizedBox(
                  height: 40,
                ),
                MaterialButton(
                  onPressed: _forgetPassword,
                  color: Colors.pink.shade700,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide.none),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Reset now ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 10,
                      ),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
