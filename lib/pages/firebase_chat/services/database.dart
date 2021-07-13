import 'dart:convert';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatDatabase {
  //create new user
  void createAndUpdateUserInfo(map, uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).set(map);
  }

  Stream<ChatProfile>getUserProfile(uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map(getProfileDataFromSnapshot);
  }

  ChatProfile getProfileDataFromSnapshot(DocumentSnapshot doc){
    return ChatProfile.fromJson(doc.data());
  }

  //return stream type search list of friends
  Stream<List<ChatProfile>> searchUserByName(String code) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('identity', isEqualTo: code)
        .snapshots()
        .map(getChatFriendFromFireStore);
  }

  //return stream type search list of friends
  Stream<List<ChatProfile>> searchUserById(String chatUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: chatUserId)
        .snapshots()
        .map(getChatFriendFromFireStore);
  }

  //return list of friends
  Stream<List<ChatProfile>> getChatFriend(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(uid)
        .snapshots()
        .map(getChatFriendFromFireStore);
  }

  //return friend object from query
  List<ChatProfile> getChatFriendFromFireStore(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatProfile.fromJson(doc.data());
    }).toList();
  }

  Future<void> updateUserToken({String uid,String token}) async {
    return  await FirebaseFirestore.instance.collection('users').doc(uid).update({'token':token});
  }

  //create chat room for every person whom we want to chat
  createChatRoom(fromId, toId, chatMap) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(fromId)
        .collection('$toId')
        .add(chatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  ///create friend list
  createFriend(currentUser, chatUser, message) {
    Map<String, dynamic> friendMap = {
      'uid': chatUser,
      'message': message,
      'timestamp': '${Timestamp.now().seconds}',
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('friends')
        .doc(chatUser)
        .set(friendMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  ///get all query message from firebase
  Stream<List<Message>> getChatRoomMessage(fromId, toId) {
    print(fromId);
    print(toId);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(fromId)
        .collection('$toId')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map(getAllMessageFromFirebase);
  }

  ///get list of message
  List<Message> getAllMessageFromFirebase(QuerySnapshot snapshot) {
    return snapshot.docs.map((item) {
      return Message(
        from: item['from'] ?? '',
        message: item['message'] ?? '',
        timeStamp: item['timestamp'] ?? '',
        type: item['type'] ?? null,
        status: item['status'] ?? null,
      );
    }).toList();
  }

  ///get all query friend from firebase
  Stream<List<ChatFriendList>> getFriend(currentUser) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('friends')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(getAllFriendFromFirebase);
  }

  ///get list of friend
  List<ChatFriendList> getAllFriendFromFirebase(QuerySnapshot snapshot) {
    return snapshot.docs.map((item) {
      return ChatFriendList.fromJson(item.data());
    }).toList();
  }

  Future<http.Response> sendNotification({token,title,body,map,status = 'call'}) async{

    final path = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      path,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAA9mpeinw:APA91bHUwuRDPPZgdFyKE4nd1dS2TbtlKarHC3MjrRx-KFR0Hqa88nXv0-HOxe-2uQeYNZgf3DRetkgJhjpYzhM9R_B_I3W9yoJi61it4hW1HwIn8lPCpchcIwvmjsix2oDmJl-sFW_u',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$body',
            'title': '$title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'type': '$status',
            'user_data' : map,
          },
          //
          // 'android':{
          //   'ttl':'4500s'
          // },
          // 'webpush':{
          //   'headers':{
          //     'TTL':'4500'
          //   }
          // },
          'to': token,
        },
      ),
    );
    print('notification ${response.body}');
    return response;
  }
}
