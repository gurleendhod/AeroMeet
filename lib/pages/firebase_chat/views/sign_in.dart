import 'package:aero_meet/pages/firebase_chat/services/auth.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/widgets/loading.dart';
import 'package:aero_meet/pages/page_with_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../main.dart';

class ChatSignIn extends StatefulWidget {
  final Function toggleView;

  ChatSignIn({this.toggleView});

  @override
  _ChatSignInState createState() => _ChatSignInState();
}

class _ChatSignInState extends State<ChatSignIn> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  final ChatAuth _auth = ChatAuth();
  final GoogleSignIn _googleSignIn = GoogleSignIn(hostedDomain: '');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String token;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((value) {
      print('token is $value');
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 35,
                            ),
                            Image.asset('assets/images/welcome.png',
                                height: 200),
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Email required' : null,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.0),
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
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.0),
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
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                  dynamic result =
                                      await _auth.signinWithEmailAndPassword(
                                          email.trim(), password.trim());
                                  if (result == null) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainPage()));
                                    print(
                                        'user uid from sign in ${result.uid}');
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
                                  'Sign in',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final user = await _signInWithGoogle();
                                if (user == null) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  ChatDatabase()
                                      .updateUserToken(
                                          token: token, uid: user.uid)
                                      .then((value) {
                                    print('user uid from sign in ${user.uid}');
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()));
                                  });
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
                                  'Sign in with Google',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
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
                                    child: Text('Don`t have an account?'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Register',
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
                  ],
                ),
              ),
            ),
          );
  }

  // ignore: missing_return
  Future<User> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final ChatDatabase _database = ChatDatabase();
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    //print(user.email);
    if (user.email != null && user.email != "") {
      assert(user.email != null);
    }
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _firebaseAuth.currentUser;
    assert(user.uid == currentUser.uid);
    if (user != null) {
      Map<String, dynamic> map = {
        'uid': '${user.uid}',
        'name': '${user.displayName.trim()}',
        'email': '${user.email.trim()}',
        'identity': '${user.uid.toString().substring(0, 5)}',
        'token': '$token',
        'image': null,
        'status': null,
      };
      _database.createAndUpdateUserInfo(map, user.uid);
      return user;
    }
  }
}
