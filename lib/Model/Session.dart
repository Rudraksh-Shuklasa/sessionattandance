class Session{
  String topic;
  String Instructor;
  var time;
  var incomingTime;

  Session(
      this.topic,
      this.Instructor,
      this.time,
      this.incomingTime
      );

  Session._({
    this.topic,
    this.Instructor,
    this.time,
    this.incomingTime
  }
  );


  factory Session.fromJson(Map<String, dynamic> json) {
    return new Session._(
        topic: json['Topic'],
        Instructor: json['Instructor'],
        time: json['Time'],
        incomingTime: json['incomingTime']
    );
  }
}