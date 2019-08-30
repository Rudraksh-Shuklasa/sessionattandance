import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sessionattandance/FirebaseRepository/SessionList.dart';
import 'package:uuid/uuid.dart';


import '../Model/Session.dart';

class NewSessionDialog extends StatefulWidget {
  final Function getQr;

  NewSessionDialog(this.getQr);

  @override
  _NewSessionDialogState createState() => _NewSessionDialogState();
}

class _NewSessionDialogState extends State<NewSessionDialog> {
  final _topicController = TextEditingController();
  final _instuctorController = TextEditingController();
  SessionList _sessionList=new SessionList();
  DateTime _selectedDate;

  void _submitData() {
   Session session;
    var uuid = new Uuid();
    String sessionId=uuid.v1();




    if (_topicController.text.isEmpty) {
      return;
    }
    if(_instuctorController.text.isEmpty)
      {
        return;
      }
    final topic = _topicController.text;
    final instuctor = _instuctorController.text;

    if (_selectedDate == null) {
      return;
    }

    int currentTime=DateTime.now().millisecondsSinceEpoch;
    session=new Session(sessionId, topic, instuctor.toString(), currentTime, null);
   _sessionList.createRecord(session);

    widget.getQr(sessionId,topic);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {

    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    ).then((pickedDate) {
     showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
       var _day = pickedDate.day;
       var _month = pickedDate.month;
       var _year = pickedDate.year;

       var _hour = value.hour;
       var _min = value.minute;

       var _date = DateTime.utc(_year ,_month , _day ,_hour ,_min);
       setState(() {
         _selectedDate=_date;
       });

       print(_date);
     });

      if (pickedDate == null) {
        return;
      }

    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Topic'),
                controller: _topicController,
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Instructor'),
                controller: _instuctorController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat("dd-MM-yyyy hh:mm a").format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Session'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),

    );
  }
}