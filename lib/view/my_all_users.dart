import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/model/my_user.dart';
import 'package:isspi_bd3/global.dart';

class MyAllUsers extends StatefulWidget {
  const MyAllUsers({super.key});

  @override
  State<MyAllUsers> createState() => _MyAllUsersState();
}

class _MyAllUsersState extends State<MyAllUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: MyFirebaseHelper().cloudUsers.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            //temps d'attente lors de la connexion à la base de donnée
            return const CircularProgressIndicator.adaptive();
          } else {
            if (!snap.hasData) {
              //il n'y a pas d'informations dans la base de donnée
              return const Center(
                child: Text("Aucune donnée"),
              );
            } else {
              List documents = snap.data!.docs;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    MyUser lesAutres = MyUser(documents[index]);
                    if(lesAutres.uid != moi.uid){
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(lesAutres.image!),
                          ),
                          title: Text(lesAutres.nom),
                          subtitle: Text(lesAutres.mail),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                moi.favoris = [...moi.favoris!, lesAutres];
                              });
                                Map<String, dynamic> data = {'FAVORIS': lesAutres};
                                MyFirebaseHelper().upadteUser(moi.uid, data);
                            },
                          ),
                        ),
                      );
                    }
                    else{
                      return Container();
                    }
                  });
            }
          }
        });
  }
}