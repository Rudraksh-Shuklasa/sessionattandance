import 'package:flutter/material.dart';



import './Screens/LoginScreen.dart';

void main() => runApp(SessionAttandence());




class SessionAttandence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Session Attandance",
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
