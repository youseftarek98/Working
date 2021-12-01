

import 'package:flutter/material.dart';
import 'package:work_in/constant/constant.dart';

class GlobalMethod{
  static void showErrorDialog({required BuildContext context, required String error}){
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
                  child: Text('error occurred' ,) ,
                )
              ],
            ),
            content: Text(error.toString() ,
              style: TextStyle(
                color: Constants.darkBlue ,
                fontSize: 20 ,
                fontStyle: FontStyle.italic ,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){Navigator.canPop(context)? Navigator.pop(context): null ;},
                child: const Text('Ok' ,
                  style: TextStyle(color: Colors.red),
                ) ,

              )
            ],
          ) ;
        }
    ) ;
  }
}