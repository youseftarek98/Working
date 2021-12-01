import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_in/widgets/all_workers_widget.dart';
import 'package:work_in/widgets/drawer_widget.dart';
import 'package:work_in/widgets/tasks_widget.dart';

class AllWorkersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
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
          title: const Text(
            'All workers',
            style: TextStyle(color: Colors.pink),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data!.docs.isNotEmpty){
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_ , index){
                      return AllWorkersWidget(
                        userID: snapshot.data!.docs[index]['id'],
                        userName: snapshot.data!.docs[index]['name'],
                        userEmail: snapshot.data!.docs[index]['email'],
                        positionInCompany:snapshot.data!.docs[index]['positionInCompany'] ,
                        phoneNumber:snapshot.data!.docs[index]['phoneNumber'] ,
                        userImage: snapshot.data!.docs[index]['userImageUrl'],

                      ) ;
                    }
                );
              }else{
                return const Center(
                  child: Text('No user found'),
                ) ;
              }
            }
            return const Center(
              child: Text('Something want wrong'),
            ) ;
          },
        ));
  }
}
/*
* ListView.builder(
          itemCount: 10,
          itemBuilder: (_ , index){
            return AllWorkersWidget() ;
          }
      ),
* */
