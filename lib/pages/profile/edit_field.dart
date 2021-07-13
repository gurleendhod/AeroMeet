import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditField extends StatefulWidget {
  final ChatProfile profile;

  EditField({@required this.profile});

  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField>
    with SingleTickerProviderStateMixin {
  TextEditingController _fieldController;
  final _formKey = GlobalKey<FormState>();
  final ChatDatabase _database = ChatDatabase();
  void onBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _fieldController = TextEditingController(text: widget.profile.name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'CHANGE ${widget.profile.name.toString().toUpperCase()}',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              onBack();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: <Widget>[
                _editFieldWidget(),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 18,
                      vertical: 30),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print('value ${_fieldController.text}');

                          Map<String, dynamic> map = {
                            'uid': '${widget.profile.uid}',
                            'name': '${_fieldController.text}',
                            'email': '${widget.profile.email}',
                            'identity': '${widget.profile.identity}',
                            'image': widget.profile.image,
                            'status': '${widget.profile.status}',
                          };
                          _database.createAndUpdateUserInfo(
                              map, widget.profile.uid);
                          Scaffold.of(_formKey.currentContext).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Name Updated',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _editFieldWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height / 18),
      child: TextFormField(
        controller: _fieldController,
        validator: (value) => value.isEmpty ? "Field can't be empty" : null,
        decoration: InputDecoration(
          hintText: "Update",
          hintStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
          ),
        ),
      ),
    );
  }
}
