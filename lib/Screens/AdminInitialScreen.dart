import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:path_provider/path_provider.dart';

import 'package:qr_utils/qr_utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';



import './LoginScreen.dart';
import '../FirebaseRepository/Authentication.dart';
import '../utils/SharedPrefrenceConstant.dart';

import '../Model/ScannerResponse.dart';
import '../FirebaseRepository/Attandance.dart';
import '../Model/User.dart';
import '../Widget/ErrorDialog.dart';
import '../Widget/AdminDashboard.dart';
import '../Widget/NewSessionDialog.dart';
import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:file_utils/file_utils.dart';



class AdminInitialScreen extends StatefulWidget {
  @override
  _AdminInitialScreenState createState() => _AdminInitialScreenState();
}

class _AdminInitialScreenState extends State<AdminInitialScreen> {
  SharedPreferences _sharedPreferences;
  String barCode="";
  User currentUser=new User("", "", "", "",false);
  List<DocumentSnapshot> list=[];
  bool isListLoding=false;
  Image _qrImg;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Attandance _attandance=new Attandance();
  File _imageFile;
  ScreenshotController _screenshotController = ScreenshotController();
  String _sessionTopic;
  String _sessionTime;
  String _sessionInsturctor;
  bool _allowWriteFile = false;




  void _logout(){
    Authentication authentication=new Authentication();
    authentication.signOutGoogle();
    _sharedPreferences.setBool(SharedPrefrenceConstant.isCureentUserLogin, false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return LoginScreen();}));

  }
  void _checkQrResponse(ScannerResponse scannerResponse)async{
    setState(() {
      isListLoding=true;
    });
    if(scannerResponse.isSuccses)
    {

      await _attandance.registerAttendance(currentUser,scannerResponse.response);
      setState(() {
        isListLoding=false;
      });


    }
    else{

      ErrorDialog dialog=new ErrorDialog(context,"Somthing want wrong",scannerResponse.errorMessage,"Ok");
      dialog.showErrorBox();
      setState(() {
        isListLoding=false;
      });
    }


  }

  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      _createFileFromString(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print("Rudraksh ->$e");
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
          body: Center(child:CircularProgressIndicator(backgroundColor: Colors.blue,strokeWidth: 3))
      );
    }
    else{

        return _qrImg != null?
        Scaffold(
            resizeToAvoidBottomPadding: true,
              appBar: AppBar(
                leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white), onPressed: () {
                  setState(() {
                    _qrImg = null;
                  });
                }),
                actions: <Widget>[
                  IconButton(icon: Icon(Icons.save), onPressed: _capturePng)
                ],
              ),
              body: RepaintBoundary(
                key: _globalKey,
                child:Center(
                child: Card(
                  child:Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 24),
                        child: Text(_sessionTopic,style: TextStyle(color: Colors.black,fontSize: 24),),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 14,left: 12,right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_sessionTime,style: TextStyle(color: Colors.black,fontSize: 18),),
                            Text(_sessionInsturctor,style: TextStyle(color: Colors.black,fontSize: 18),),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),
                      _qrImg
                    ],
                  )

                ),
              ),
              )

            ) :
        Scaffold(
          body: AdminDashboard(_logout, currentUser),
          floatingActionButton:_getFAB()
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

    requestWritePermission();

    setState(()  {
      _sharedPreferences=_sharedPreferences;
      currentUser=new User(
          _sharedPreferences.getString(SharedPrefrenceConstant.userId),
          _sharedPreferences.getString(SharedPrefrenceConstant.userEmail),
          _sharedPreferences.getString(SharedPrefrenceConstant.userName),
          _sharedPreferences.getString(SharedPrefrenceConstant.userPhoto),
          _sharedPreferences.getBool(SharedPrefrenceConstant.isAdmin)
      );
    });

  }
  requestWritePermission() async {
    PermissionStatus permissionStatus = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);

    if (permissionStatus == PermissionStatus.authorized) {
      setState(() {
        _allowWriteFile = true;
      });
    }
  }


  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Image.asset("assets/Images/qr-code.png"),
            backgroundColor: Colors.blue,
            onTap: scan,
            label: 'Scan QR',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.library_add,color: Colors.white,),
            backgroundColor:Colors.blue,
            onTap: _openSessionForm,
            label: 'Add Session',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue)
      ],
    );
  }

  void _openSessionForm() {
    showModalBottomSheet(context: context , builder: (bCtx) {
      return NewSessionDialog(_generateQR);
    });
  }

  void _generateQR(String content,String topic,String currentTime,String instructor) async {
    if (content.trim().length == 0) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Please enter qr content')));
      setState(() {
        _qrImg = null;
      });
      return;
    }
    Image image;
    try {
      image = await QrUtils.generateQR(content);
    } on PlatformException {
      image = null;
    }

    
    setState(() {
      _qrImg = image;
      _sessionTopic=topic;
      _sessionTime=currentTime;
      _sessionInsturctor=instructor;

    });


  }

//  void _takeScreenShort(){
//    _screenshotController.capture().then((File image) async {
//      final result =
//      await ImageGallerySaver.saveImage(image.readAsBytesSync());
//    });
//    }



  Future<String> _createFileFromString(String encodedStr) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getExternalStorageDirectory()).path;



   FileUtils.mkdir(["/storage/emulated/0/SessionAttendance"]);



    File file = File("storage/emulated/0/SessionAttendance/" + _sessionTopic.replaceAll(" ", "") + ".png");

    ErrorDialog dialog=new ErrorDialog(context,"Image save","Image was saved successfully","Ok");
    dialog.showErrorBox();


    await file.writeAsBytes(bytes);
    var a=file.path;
    print("Rudraksh -> $a");
    return file.path;
  }

  }


