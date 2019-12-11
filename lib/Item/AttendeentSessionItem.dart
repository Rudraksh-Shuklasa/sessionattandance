import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../Model/Session.dart';

class AttendeentSessionItem extends StatefulWidget {

  Session _session;
  AttendeentSessionItem(this._session);
  @override
  _AttendeentSessionItemState createState() => _AttendeentSessionItemState();
}

class _AttendeentSessionItemState extends State<AttendeentSessionItem> {
  var time = new DateFormat('dd-MM-yyyy hh:mm a ');


  @override
  Widget build(BuildContext context) {
    return Container(
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
                          Text(widget._session.topic,style: TextStyle(fontSize: 14,color: Colors.black),),
                          Text(widget._session.instructor),
                        ],
                      )
                ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget._session.time.toString()),
                        Text(time.format(new DateTime.fromMillisecondsSinceEpoch((widget._session.incomingTime)))),
                      ],
                    ) ,
                  )

                  ],
                )
              )

            ],
         ),
      )
    );
  }
}
