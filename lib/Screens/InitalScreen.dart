import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import './LoginScreen.dart';
import '../FirebaseRepository/Authentication.dart';
import '../utils/SharedPrefrenceConstant.dart';
import '../FirebaseRepository/Authentication.dart';

class InitalScreen extends StatefulWidget {
  @override
  _InitalScreenState createState() => _InitalScreenState();
}

class _InitalScreenState extends State<InitalScreen> {
  SharedPreferences _sharedPreferences;
  String userName="";
  String userPhoto="";


   void _logout(){
     Authentication authentication=new Authentication();
     authentication.signOutGoogle();

     _sharedPreferences.setBool(SharedPrefrenceConstant.isCureentUserLogin, false);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){LoginScreen();}));

   }

  @override
  void initState() {
    var result=SharedPreferences.getInstance().then((sharedPrefrence){
      _sharedPreferences=sharedPrefrence;
      setState(() {
       _sharedPreferences=sharedPrefrence;
      });


    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(_sharedPreferences.getString(SharedPrefrenceConstant.userPhoto)),
        title: Text(_sharedPreferences.getString(SharedPrefrenceConstant.userName)),
        actions: <Widget>[
          InkWell(
             onTap: _logout,
             child:Image.asset("assets/Images/log-out.png") ,
          )
        ],

      ),
    );

  }
}
