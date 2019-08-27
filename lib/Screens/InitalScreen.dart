import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import './LoginScreen.dart';
import '../FirebaseRepository/Authentication.dart';
import '../utils/SharedPrefrenceConstant.dart';

class InitalScreen extends StatefulWidget {
  @override
  _InitalScreenState createState() => _InitalScreenState();
}

class _InitalScreenState extends State<InitalScreen> {
  SharedPreferences _sharedPreferences;
  String userName="";
  String userPhoto="";

  @override
  void initState() {
    var result=SharedPreferences.getInstance().then((sharedPrefrence){
      _sharedPreferences=sharedPrefrence;
      setState(() {
        userName=_sharedPreferences.getString(SharedPrefrenceConstant.userName);
        userPhoto=_sharedPreferences.getString(SharedPrefrenceConstant.userPhoto);
      });


    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(_sharedPreferences.getString(SharedPrefrenceConstant.userPhoto)),
        title: Text(userName),

      ),
    );

  }
}
