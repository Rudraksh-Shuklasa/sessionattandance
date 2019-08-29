import 'package:flutter/material.dart';

class ErrorDialog{
  BuildContext _context;
  String _title;
  String _message;
  String _btnText;

  ErrorDialog(
      this._context,
      this._title,
      this._message,
      this._btnText
      );



  void showErrorBox(){
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
              child: Text(_btnText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}