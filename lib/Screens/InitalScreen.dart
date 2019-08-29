import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import './LoginScreen.dart';
import '../FirebaseRepository/Authentication.dart';
import '../utils/SharedPrefrenceConstant.dart';
import '../FirebaseRepository/Authentication.dart';
import '../Model/ScannerResponse.dart';
import '../FirebaseRepository/Attandance.dart';
import '../Model/User.dart';
import '../Widget/ErrorDialog.dart';
import '../Widget/AttendeentSessionItem.dart';
import '../Model/Session.dart';
class InitalScreen extends StatefulWidget {
  @override
  _InitalScreenState createState() => _InitalScreenState();
}

class _InitalScreenState extends State<InitalScreen> {
  SharedPreferences _sharedPreferences;
  String barCode="";
  User currentUser;
  List<DocumentSnapshot> list=[];
  bool isListLoding=true;

  Attandance _attandance=new Attandance();

   void _logout(){
     Authentication authentication=new Authentication();
     authentication.signOutGoogle();
     _sharedPreferences.setBool(SharedPrefrenceConstant.isCureentUserLogin, false);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return LoginScreen();}));

   }

   void _checkQrResponse(ScannerResponse scannerResponse)async{
     if(scannerResponse.isSuccses)
      {
        _attandance.registerAttendance(currentUser,scannerResponse.response);
         setInit();
      }
     else{
       ErrorDialog dialog=new ErrorDialog(context,"Somthing want wrong",scannerResponse.errorMessage,"Ok");
       dialog.showErrorBox();
     }


   }

  @override
  void initState() {
     setInit();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
     if(isListLoding)
       {
         return Scaffold(
           appBar: AppBar(

           ),

           body: Center(
             child:CircularProgressIndicator(backgroundColor: Colors.deepOrange,strokeWidth: 3),
           )
         );
       }
     else{
       return Scaffold(
         appBar: AppBar(
           leading: Image.network(currentUser.photoUrl),
           title: Text(currentUser.name),
           actions: <Widget>[
             InkWell(
               onTap: _logout,
               child: Image.asset("assets/Images/log-out.png"),
             )
           ],

         ),

         body:Container(
           child: ListView.builder(
               itemCount:list.length ,
               itemBuilder:(context,pos){
                 return GestureDetector(
                   child:AttendeentSessionItem(Session(list[pos].data['Topic'].toString(),list[pos].data['Instructor'].toString(),list[pos].data['Time'],list[pos].data['incomingTime'])) ,
                 );
               }

           ) ,
         ),
         floatingActionButton:FloatingActionButton(
           backgroundColor: Colors.deepOrange,
           child: Image.asset("assets/Images/qr-code.png"),
           onPressed: () => scan(),
         ),
       );
     }

  }



  Future scan() async  {
    ScannerResponse scannerResponse;
    try {
      String barcode = await BarcodeScanner.scan();
      scannerResponse=ScannerResponse(true, barcode, "");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        scannerResponse=ScannerResponse(false, "", "Camera access denied");
      } else {
        scannerResponse=ScannerResponse(false, "", "this.barCode = 'Unknown error: $e");
      }
    } on FormatException{
      scannerResponse=ScannerResponse(false, "","Not Scann Anythimg");
    } catch (e) {
      scannerResponse = ScannerResponse(false, "", "Unknown error: $e");
    }
    _checkQrResponse(scannerResponse);
  }

  Future setInit() async {
    _sharedPreferences=await SharedPreferences.getInstance();

      setState(()  {
        _sharedPreferences=_sharedPreferences;
        currentUser=new User(
            _sharedPreferences.getString(SharedPrefrenceConstant.userId),
            _sharedPreferences.getString(SharedPrefrenceConstant.userEmail),
            _sharedPreferences.getString(SharedPrefrenceConstant.userName),
            _sharedPreferences.getString(SharedPrefrenceConstant.userPhoto)
        );
      });
      var result= await _attandance.getAttendedEvent(currentUser.uid).then((value){
        setState(()  {
          list=value;
          isListLoding=false;
        });
      });



    }
  }

