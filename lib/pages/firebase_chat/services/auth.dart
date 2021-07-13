import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //firebase sign in
  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //firebase sign up
  Future registrationWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //get firebase user
  ChatUser _userFromFirebase(User user) {
    return user != null ? ChatUser(uid: user.uid) : null;
  }

  //reset password
  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
  //get stream of chatUser
  Stream<ChatUser> get getChatUser{
    return _auth.userChanges().map(_userFromFirebase);
  }
}
