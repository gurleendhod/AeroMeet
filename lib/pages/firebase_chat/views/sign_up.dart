import 'package:aero_meet/pages/firebase_chat/services/auth.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/widgets/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatSignUp extends StatefulWidget {
  final Function toggleView;

  ChatSignUp({this.toggleView});

  @override
  _ChatSignUpState createState() => _ChatSignUpState();
}

class _ChatSignUpState extends State<ChatSignUp> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  final ChatAuth _auth = ChatAuth();
  final ChatDatabase _database = ChatDatabase();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String token;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((value) {
      print('token is $value');
      setState(() {
        token = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      margin: const EdgeInsets.only(top: 30.0),
                      child: SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Image.asset('assets/images/welcome.png',
                                  height: 200),
                              TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? 'Name required' : null,
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 16.0),
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                              ),
                              TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? 'Email required' : null,
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 16.0),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: (val) =>
                                    val.isEmpty ? 'Password required' : null,
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 16.0),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text('Forgot Password')),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    dynamic result = await _auth
                                        .registrationWithEmailAndPassword(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      print(
                                          'user uid from sign up ${result.uid}');
                                      Map<String, dynamic> map = {
                                        'uid': '${result.uid}',
                                        'name': '${name.trim()}',
                                        'email': '${email.trim()}',
                                        'identity':
                                            '${result.uid.toString().substring(0, 5)}',
                                        'token': '$token',
                                        'image': null,
                                        'status': null,
                                      };
                                      _database.createAndUpdateUserInfo(
                                          map, result.uid);
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Colors.blue
                                      ])),
                                  child: Center(
                                      child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text('Already have an account?'),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.toggleView();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Sign in',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
