import 'package:cloud_firestore/cloud_firestore.dart';

class Session{
  String sessionId;
  String topic;
  String instructor;
  var time;
  var incomingTime;

  Session(
      this.sessionId,
      this.topic,
      this.instructor,
      this.time,
      this.incomingTime
      );

  Session._({
    this.sessionId,
    this.topic,
    this.instructor,
    this.time,
    this.incomingTime
  }
  );


  factory Session.fromJson(Map<String, dynamic> json) {
    return new Session._(
        sessionId: json['SessionId'],
        topic: json['Topic'],
        instructor: json['Instructor'],
        time: json['Time'],
        incomingTime: json['incomingTime']
    );
  }
}