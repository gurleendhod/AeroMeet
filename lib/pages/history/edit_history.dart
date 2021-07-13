import 'package:aero_meet/constant/text_field_style.dart';
import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../main.dart';

// ignore: must_be_immutable
class EditHistory extends StatelessWidget {
  final HostModel host;
  final int position;

  EditHistory({this.host, this.position});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _channelController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Box<HostModel> hostBox = Hive.box<HostModel>(hostBoxName);

  @override
  Widget build(BuildContext context) {
    _titleController.text = host.title;
    _channelController.text = host.channelID;
    _dateController.text = host.date;
    _timeController.text = host.time;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Edit Page'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _titleController,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Meeting Title'),
                validator: (val) => val.isEmpty ? 'Enter Meeting Title' : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _channelController,
                decoration: textInputDecoration.copyWith(
                    hintText: 'Create a Channel ID'),
                validator: (val) => val.isEmpty ? 'Enter Channel ID' : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Start Date'),
                validator: (val) => val.isEmpty ? 'Enter Meeting Date' : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _timeController,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Start Time'),
                validator: (val) => val.isEmpty ? 'Enter Meeting Time' : null,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  'Create Room',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onHostUpadte,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onHostUpadte() {
    if (_formKey.currentState.validate()) {
      String title = _titleController.text;
      String channelID = _channelController.text;
      String date = _dateController.text;
      String time = _timeController.text;

      final host =
          HostModel(title: title, channelID: channelID, date: date, time: time);
      hostBox.put(position, host).then((value) {
        Scaffold.of(_formKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(
              'Host updated',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(_formKey.currentContext);
        });
      }).catchError((e) {
        Scaffold.of(_formKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(
              '${e.toString()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    }
  }
}
