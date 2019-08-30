import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import '../Model/User.dart';
import 'package:sessionattandance/Item/AttendeentSessionItem.dart';
import '../Model/Session.dart';

class UserDashboard extends StatefulWidget {

  Function _logout;
  User _currentUser;

  UserDashboard(this._logout,this._currentUser);


  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(widget._currentUser.userPhoto),
        title: Text(widget._currentUser.name),
        actions: <Widget>[
          InkWell(
            onTap: widget._logout,
            child: Image.asset("assets/Images/log-out.png"),
          )
        ],

      ),

      body:Container(
          child: GestureDetector(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Users').document(widget._currentUser.uid).collection("SessionAttended").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,strokeWidth: 3));
                    default:
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {

                              var time = new DateTime.now().millisecondsSinceEpoch ;
                              Timestamp date_ = document['incomingTime'];
                              if(date_ !=null) {
                                time =date_.millisecondsSinceEpoch;
                              }

                          return new  AttendeentSessionItem(Session(document['SessionId'].toString(),document['Topic'].toString(),document['Instructor'].toString(),document['Time'],time));
                        }).toList(),
                      );
                  }
                },

              )
          )

      ),


    );
  }
}
