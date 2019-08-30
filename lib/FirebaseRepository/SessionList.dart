import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:sessionattandance/Model/Session.dart';
import '../utils/SharedPrefrenceConstant.dart';



class SessionList{

  final databaseReference = Firestore.instance;
  void createRecord(Session session) async {
    await databaseReference.collection("Sessions")
        .document(session.sessionId)
        .setData({
          SharedPrefrenceConstant.SessionId:session.sessionId,
          SharedPrefrenceConstant.SessionTopic:session.topic,
          SharedPrefrenceConstant.SessionInstructor:session.instructor,
          SharedPrefrenceConstant.SessionTime:session.time
    });
  }
}