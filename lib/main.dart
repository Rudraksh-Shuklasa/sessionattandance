import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



import './Screens/LoginScreen.dart';
import './Screens/UserInitalScreen.dart';
import './Screens/AdminInitialScreen.dart';
import './utils/SharedPrefrenceConstant.dart';
void main() => runApp(SessionAttandence());



class SessionAttandence extends StatefulWidget {
  @override
  _SessionAttandenceState createState() => _SessionAttandenceState();
}

class _SessionAttandenceState extends State<SessionAttandence> {
  Widget nextScreen=Container(child: Text(""),);

  getUserStatus(){Future<SharedPreferences> sharedPreferences =   SharedPreferences.getInstance().then((value){

    if((value.getBool(SharedPrefrenceConstant.isCureentUserLogin) == null))
    {
      setState(() {
        nextScreen= LoginScreen();
      });

    }
    else if(value.getBool(SharedPrefrenceConstant.isCureentUserLogin))
    {
      if(value.getBool(SharedPrefrenceConstant.isAdmin))
        {
          setState(() {
            nextScreen= AdminInitialScreen();
          });
        }
      else{
        setState(() {
          nextScreen= UserInitalScreen();
        });
      }


    }
    else{
      setState(() {
        nextScreen= LoginScreen();
      });
    }
  });

  }

  @override
  void initState() {
    getUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Session Attandance",
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent,
          primarySwatch: Colors.blue,
        ),
        home:Scaffold(
          body: nextScreen,
        ),
      );
    }

}

