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

  @override
  void initState() {
    var result=SharedPreferences.getInstance().then((sharedPrefrence){
      _sharedPreferences=sharedPrefrence;

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_sharedPreferences.getString(SharedPrefrenceConstant.userName)),
      ),
    );

  }
}
