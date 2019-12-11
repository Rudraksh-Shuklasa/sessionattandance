import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../Model/Session.dart';
import 'package:sessionattandance/Item/SessionItem.dart';
import '../Model/Attendy.dart';
import 'package:sessionattandance/Item/AttendyItem.dart';
import 'AdminInitialScreen.dart';


class AttendyListScreen extends StatefulWidget {
  Session _session;

  AttendyListScreen(this._session);

  @override
  _AttendyListScreenState createState() => _AttendyListScreenState();
}

class _AttendyListScreenState extends State<AttendyListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: gotoMainScreen),
          title: Text(widget._session.topic,style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 12),
            child: Center(
              child:  Text((widget._session.time),style: TextStyle(fontSize: 12,color: Colors.white),),
            ) ,
           )


          ],
        ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Sessions').document(widget._session.sessionId).collection('Attendy').snapshots(),
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

                    return new AttendyItem(Attendy(document['userId'].toString(),document['userPhoto'].toString(),document['userName'].toString(),document['timeStamp']));
                  }).toList(),
                );
            }
          },

        ),
      ),
    );
  }

  void gotoMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminInitialScreen()),
    );
  }
}
