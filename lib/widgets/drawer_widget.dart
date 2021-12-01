
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_in/constant/constant.dart';
import 'package:work_in/inner_screens/add_task.dart';
import 'package:work_in/inner_screens/profile.dart';
import 'package:work_in/screens/all_workes.dart';
import 'package:work_in/screens/tasks.dart';
import 'package:work_in/user_state.dart';
class DrawerWidget extends StatelessWidget {
// Constants _constants = Constants() ;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.cyan
            ),
            child: Column(
              children: [
                Flexible( flex: 2 , child: Image.network( 'https://image.flaticon.com/icons/png/128/1055/1055672.png',
                ) ,) ,
              const SizedBox(height: 20,) ,
              Flexible(child:   Text('Work In' ,
              style: TextStyle(color:Constants.darkBlue ,
              fontSize: 25.0 ,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
              ),
              ) ,
              ) ,
              ],
            ),
          ),
          const SizedBox(height: 30,) ,
          _listTile(label: 'All Tasks' , tap: (){_navigateToTaskScreen(context) ;} , icon: Icons.task_outlined) ,
          _listTile(label: 'My Account' , tap: (){_navigateToProfileScreen(context) ;} , icon: Icons.settings) ,
          _listTile(label: 'Registered Works' , tap: (){_navigateToAllWorkersScreen(context) ;} , icon: Icons.workspaces_outline) ,
          _listTile(label: 'Add Task' , tap: (){
            _navigateToAddTaskScreen(context) ;
          } , icon: Icons.add_task_outlined) ,
          const Divider(thickness: 1,) ,
          _listTile(label: 'Logout' , tap: (){
            _logout(context) ;
          } , icon: Icons.logout) ,

        ],
      )
    );
  }

  void _navigateToProfileScreen(BuildContext context){
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser ;
    final uid = user!.uid ;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  ProfileScreen(userID: uid,))) ;
  }
  void _navigateToAllWorkersScreen(BuildContext context){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  AllWorkersScreen())) ;
  }

  Widget _listTile({required String label, required Function tap, required IconData icon}){
    return ListTile(
      onTap: (){
        tap() ;
      },
      leading: Icon(icon , color: Constants.darkBlue,) ,
      title:
      Text(
        label ,
        style: TextStyle(
          color: Constants.darkBlue ,
          fontSize: 20 ,
          fontStyle: FontStyle.italic ,
        ),
      ) ,


    );
  }

  void _logout(BuildContext context){
    final FirebaseAuth _auth = FirebaseAuth.instance ;
    showDialog(context: context,
        builder: (_){
      return AlertDialog(
        title: Row(
          children: [
            Padding(padding: const EdgeInsets.all(8.0) ,
            child: Image.network(
              'https://images.unsplash.com/photo-1550439062-609e1531270e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80' ,
              height: 20.0,
              width: 20.0,
            ) ,
            ),
             const Padding( padding:EdgeInsets.all(8.0) ,
            child: Text('Sign out' ,) ,
            )
          ],
        ),
        content: Text('Do you wants Sign out' ,
          style: TextStyle(
            color: Constants.darkBlue ,
            fontSize: 20 ,
            fontStyle: FontStyle.italic ,
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.canPop(context)? Navigator.pop(context): null ;
            },
            child: const Text('Cancel') ,
          ) ,
          TextButton(
            onPressed: ()async{
            await  _auth.signOut() ;
              Navigator.canPop(context)? Navigator.pop(context): null ;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => UserState() )) ;
              },
            child: const Text('Ok' ,
            style: TextStyle(color: Colors.red),
            ) ,

          )
        ],
      ) ;
        }
    ) ;
  }

  void _navigateToAddTaskScreen(BuildContext context){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  AddTaskScreen())) ;
  }

  void _navigateToTaskScreen(BuildContext context){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>   TasksScreen())) ;
  }
}
