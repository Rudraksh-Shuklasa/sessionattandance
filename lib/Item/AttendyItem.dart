import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/Attendy.dart';

class AttendyItem extends StatefulWidget {
  Attendy _attendy;
  AttendyItem(this._attendy);
  @override
  _AttendyItemState createState() => _AttendyItemState();
}

class _AttendyItemState extends State<AttendyItem> {
  var time = new DateFormat('hh:mm a  | dd-MM-yy');
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
                  child: Row(
                    children: <Widget>[
                      Container(

                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                             Container(
                               height:42,
                               width: 42,
                               child: Image.network(widget._attendy.photoUrl),
                             )
                            ],
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget._attendy.name,style: TextStyle(color: Colors.black,fontSize: 16),),
                            Text(time.format(new DateTime.fromMillisecondsSinceEpoch((widget._attendy.incomeingTime))))
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


