import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_in/screens/auth/login.dart';
import 'package:work_in/screens/auth/sign_up.dart';
import 'package:work_in/screens/tasks.dart';
import 'package:work_in/user_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _appInitialization = Firebase.initializeApp();
  return FutureBuilder(
      future: _appInitialization,
      builder: (_ ,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting
        ){
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home:  Scaffold(
              body:Center(
                child: Text("App is Loading" , style: TextStyle( fontWeight: FontWeight.bold , fontSize: 50)),
              ),
            ),
          );
        }else if(snapshot.hasError){
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home:  Scaffold(
              body: Center(
                child: Text("An error has been occurred" , style: TextStyle(color: Colors.red  , fontSize: 40, fontWeight: FontWeight.bold),),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Work in',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFEDE7DC),
            primarySwatch: Colors.blue,
          ),
          home:   UserState(),
        );
      }
  ) ;
  }
}

/*
*   return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Work in',
      theme: ThemeData(
     scaffoldBackgroundColor: const Color(0xFFEDE7DC),
        primarySwatch: Colors.blue,
      ),
      home:   LoginScreen(),
    );
* */