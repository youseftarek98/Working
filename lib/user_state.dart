import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_in/screens/auth/login.dart';
import 'package:work_in/screens/tasks.dart';
class UserState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:FirebaseAuth.instance.authStateChanges() ,
        builder: (_ ,userSnapshot){
        if(userSnapshot.data == null){
          print('User didn\'t login yet ') ;
          return  LoginScreen() ;
        }else if(userSnapshot.hasData){
          print('User is logged in ') ;

          return TasksScreen() ;
        }else if(userSnapshot.hasError){
          return  const Center(
            child: Text("An error has been occurred" , style: TextStyle(color: Colors.red , fontSize: 40,  fontWeight: FontWeight.bold),),
          ) ;
        }
        return  const Scaffold(
          body: Center(
            child: Text("Something want wrong" , style: TextStyle(color: Colors.red , fontSize: 40,  fontWeight: FontWeight.bold),),
          ),
        ) ;
        }
    );
  }
}
