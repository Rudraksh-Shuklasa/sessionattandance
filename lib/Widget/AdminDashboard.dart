import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';



import '../Model/User.dart';
import 'package:sessionattandance/Item/SessionItem.dart';
import '../Model/Session.dart';


class AdminDashboard extends StatefulWidget {
  Function _logout;
  User _currentUser;
  AdminDashboard(this._logout,this._currentUser);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(widget._currentUser.userPhoto),
        title: Text(widget._currentUser.name),
        backgroundColor: Colors.blue,
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
                stream: Firestore.instance.collection('Sessions').snapshots(),
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
                          return new  SessionItem(Session(document['SessionId'],document['Topic'].toString(),document['Instructor'].toString(),document['Time'],document['incomingTime']));
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
