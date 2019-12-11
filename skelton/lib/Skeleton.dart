

import 'package:flutter/material.dart';

import 'SekltonEffect.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;
  final Key key;

  Skeleton({this.key, this.height = 150, this.width = 50 }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Container(
        width:  double.infinity,
        height: 256,
        child: Card(
          elevation: 5,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),

          ),
          margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),

          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                 child: SkeletonEffect(widget.key,92,double.infinity)
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6,horizontal: 4),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 12,vertical:6),
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           Container(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 SkeletonEffect(widget.key,12,112),
                                 SizedBox(
                                   height: 24,
                                 ),
                                 SkeletonEffect(widget.key,12,112),
                                 SizedBox(
                                   height: 24,
                                 ),
                                 SkeletonEffect(widget.key,12,double.infinity),

                               ],
                             ),
                           )
                          ],
                        )
                    ),


        ],
      ),
    )
            ],
          ),
        )
    );
  }
}