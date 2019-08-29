import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../Model/User.dart';
import '../utils/SharedPrefrenceConstant.dart';
import '../Widget/ErrorDialog.dart';
import '../Model/Session.dart';
class Attandance{
  final databaseReference = Firestore.instance;


  Future<bool> registerAttendance(User user,String sessionId) async {
    var result;

  try{

    final DocumentReference documentReference =
    Firestore.instance.collection("Sessions").document(sessionId);

    documentReference.snapshots().listen((datasnapshot) async {
      if (datasnapshot.exists) {
        await databaseReference.collection("Sessions")
            .document(sessionId)
            .collection("Attendy")
            .document(user.uid)
            .setData({
          SharedPrefrenceConstant.userId: user.uid,
          SharedPrefrenceConstant.userName: user.name,
          SharedPrefrenceConstant.userPhoto: user.photoUrl,
          SharedPrefrenceConstant.timeStamp:DateTime.now().millisecondsSinceEpoch

        });
        addSessionToUser(user.uid,sessionId);
        Fluttertoast.showToast(
            msg: "Thank you for attending",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else  {
        Fluttertoast.showToast(
            msg: "Wrong bar code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    }
    catch(e)
    {
      result= false;
    }

   return result;
  }

  Future<List<DocumentSnapshot>>  getAttendedEvent(String userId) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").document(userId).collection("SessionAttended").getDocuments();
    List<DocumentSnapshot> list = querySnapshot.documents;
    return list;
   }



   void addSessionToUser(String userId,String sessionId)
   {
     DocumentReference documentReference = Firestore.instance.collection("Sessions").document(sessionId);
     documentReference.get().then((datasnapshot) {
       if (datasnapshot.exists) {

           Session session=  Session.fromJson(datasnapshot.data);

           Map<String, dynamic>map = {"incomingTime":DateTime.now().millisecondsSinceEpoch };
           datasnapshot.data.addAll(map);
           databaseReference.collection("Users")
               .document(userId).collection("SessionAttended").document(sessionId)
               .setData(datasnapshot.data);

       }
       else{
         print("No such user");
       }
     });
   }


}