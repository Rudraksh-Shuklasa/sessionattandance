import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



import './UserInitalScreen.dart';
import './AdminInitialScreen.dart';
import '../FirebaseRepository/Authentication.dart';
import '../utils/SharedPrefrenceConstant.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreferences sharedPreferences;
  bool isLoding=false;

  @override
  void initState() {
    setSharedPrefrence();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


if(isLoding)
  {
    return Scaffold(
        body: Center(
          child: CircularProgressIndicator(backgroundColor: Colors.cyanAccent,strokeWidth: 2,),
        )
    );



  }
else
  {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset("assets/Images/sa_40.png",width: 216,height: 216,),
              ),
              _signInButton()

            ],
          )
      ),
    );
  }

  }



  Widget _signInButton() {
    Authentication authentication=new Authentication();
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        setState(() {
          isLoding=true;
        });
        authentication.signInWithGoogle().whenComplete(() {
          setState(() {
            isLoding=false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                if(sharedPreferences.getBool(SharedPrefrenceConstant.isAdmin)==null || !(sharedPreferences.getBool(SharedPrefrenceConstant.isAdmin)))
                  {
                    return UserInitalScreen();
                  }
                else{
                  return AdminInitialScreen();
                }

              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/Images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future setSharedPrefrence() async {
    await SharedPreferences.getInstance().then((value){
      setState(() {
        sharedPreferences=value;
      });
    });
  }


}
