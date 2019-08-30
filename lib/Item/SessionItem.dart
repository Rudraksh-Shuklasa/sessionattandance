import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../Model/Session.dart';
import '../Screens/AttendyListScreen.dart';


class SessionItem extends StatefulWidget {

  Session _session;
  SessionItem(this._session);
  @override
  _SessionItemItemState createState() => _SessionItemItemState();
}

class _SessionItemItemState extends State<SessionItem> {
  var time = new DateFormat('hh:mm a  | dd-MM-yy');


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _getAttendyList,
      child:  Container(
          padding: EdgeInsets.all(8),
          child:Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(widget._session.topic,style: TextStyle(fontSize: 18,color: Colors.black),),
                                Text(widget._session.instructor),
                              ],
                            )
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(time.format(new DateTime.fromMillisecondsSinceEpoch((widget._session.time))))
                            ],
                          ) ,
                        )

                      ],
                    )
                )

              ],
            ),
          )
      ),
    );

  }

  void _getAttendyList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AttendyListScreen(widget._session)),
    );
  }
}
