import 'dart:convert';
import 'dart:io';
import 'package:aero_meet/pages/firebase_chat/audio_call/audio_index.dart';
import 'package:aero_meet/pages/firebase_chat/audio_call/chat_room_audio_screen.dart';
import 'package:aero_meet/pages/firebase_chat/audio_call/incoming_audio_call_screen.dart';
import 'package:aero_meet/pages/firebase_chat/common/chat_line.dart';
import 'package:aero_meet/pages/firebase_chat/common/common_method.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/modal/message.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:aero_meet/pages/firebase_chat/video_call/index.dart';
import 'package:aero_meet/pages/firebase_chat/video_call/outgoing_call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatConversation extends StatefulWidget {
  final ChatProfile friend;
  final ChatProfile myProfile;

  ChatConversation({this.friend, this.myProfile});

  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  //scroll controller
  final ScrollController listScrollController = ScrollController();
  TextEditingController _messageController = TextEditingController();
  String message = '';
  PickedFile imageFile;
  File file;

  @override
  Widget build(BuildContext context) {
    //database instance
    ChatDatabase _database = ChatDatabase();
    //current logged in user
    final currentUser = Provider.of<ChatUser>(context);
    //current chat user
    final chatUser = widget.friend.uid;
    // print('image'+widget.friend.image);

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: StreamBuilder<List<Message>>(
                stream: _database.getChatRoomMessage(currentUser.uid, chatUser),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      ///If video call received by receiver
                      ///then P2P video connection happen in
                      ///IndexPage
                      if (snapshot.data.first.type == 'call' &&
                          snapshot.data.first.status == 'received') {
                        String channel = snapshot.data.first.timeStamp;

                        print('channel $channel');

                        return IndexPage(
                          channel: channel,
                          friend: widget.friend,
                          currentUserUID: currentUser.uid,
                        );
                      }

                      ///when caller try to call
                      ///and receiver not receive yet
                      ///call see this screen
                      if (snapshot.data.first.type == 'call' &&
                          snapshot.data.first.from == currentUser.uid &&
                          snapshot.data.first.status != 'ended') {
                        return OutgoingCallScreen(
                          currentUserUid: currentUser.uid,
                          toUserUid: chatUser,
                          name: widget.friend.name,
                        );
                      }

                      ///If call received by receiver
                      ///then P2P connection happen in
                      ///chatRoomAudioScreen
                      if (snapshot.data.first.type == 'audio_call' &&
                          snapshot.data.first.status == 'received') {
                        String channel = snapshot.data.first.timeStamp;

                        print('channel $channel');

                        return AudioIndexPage(
                          friend: widget.friend,
                          currentUserUID: currentUser.uid,
                          channel: channel,
                        );
                      }

                      ///when caller try to call
                      ///and receiver not receive yet
                      ///call see this screen
                      if (snapshot.data.first.type == 'audio_call' &&
                          snapshot.data.first.from == currentUser.uid &&
                          snapshot.data.first.status != 'ended') {
                        return OutgoingCallScreen(
                          name: widget.friend.name,
                          toUserUid: widget.friend.uid,
                          currentUserUid: currentUser.uid,
                        );
                      }
                    }

                    ///By default chat screen view
                    ///where show all messages
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('${widget.friend.name}'),
                        leading: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: widget.friend.image == null ||
                                    widget.friend.image == ''
                                ? Image.network(
                                    'https://cdn4.iconfinder.com/data/icons/user-people-2/48/6-512.png',
                                    width: 74,
                                    height: 74,
                                    fit: BoxFit.cover,
                                  )
                                : Image.memory(
                                    base64Decode(widget.friend.image),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.videocam,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                // print('Current user uid : ${currentUser.uid}');
                                // print('Friend uid : ${widget.friend.uid}');

                                Map<String, dynamic> map = {
                                  'type': 'call',
                                  'message': 'call started',
                                  'status': 'not received',
                                  'from': '${currentUser.uid}',
                                  'timestamp': '${Timestamp.now().seconds}'
                                };

                                ///create chat room for current user
                                _database.createChatRoom(
                                    currentUser.uid, chatUser, map);

                                ///create chat room for chat user
                                _database.createChatRoom(
                                    chatUser, currentUser.uid, map);

                                ///update friend list for current user
                                _database.createFriend(
                                    currentUser.uid, chatUser, 'call started');

                                ///update friend list for chat user
                                _database.createFriend(
                                    chatUser, currentUser.uid, 'call started');

                                ///sent notification to notify
                                ///chat user
                                _database.sendNotification(
                                    token: widget.friend.token,
                                    title: '${widget.friend.name} calling',
                                    body: 'Please received my call',
                                    status: 'call',
                                    map: widget.myProfile.toJson());
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                print('Current user uid : ${currentUser.uid}');
                                print('Friend uid : ${widget.friend.uid}');

                                Map<String, dynamic> map = {
                                  'type': 'audio_call',
                                  'message': 'call started',
                                  'status': 'not received',
                                  'from': '${currentUser.uid}',
                                  'timestamp': '${Timestamp.now().seconds}'
                                };

                                ///create chat room for current user
                                _database.createChatRoom(
                                    currentUser.uid, chatUser, map);

                                ///create chat room for chat user
                                _database.createChatRoom(
                                    chatUser, currentUser.uid, map);

                                ///update friend list for current user
                                _database.createFriend(
                                    currentUser.uid, chatUser, 'call started');

                                ///update friend list for chat user
                                _database.createFriend(
                                    chatUser, currentUser.uid, 'call started');

                                ///sent notification to notify
                                ///chat user
                                _database.sendNotification(
                                    token: widget.friend.token,
                                    title: '${widget.friend.name} calling',
                                    body: 'Please received my call',
                                    status: 'audio_call',
                                    map: widget.myProfile.toJson());
                              }),
                        ],
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              controller: listScrollController,
                              reverse: true,
                              itemBuilder: (_, index) {
                                return ChatLine(
                                  message: snapshot.data.elementAt(index),
                                  currentUser: currentUser.uid,
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0))),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(right: 16.0),
                                  child: Material(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () async {
                                          imageFile =
                                              await ChatCommon.getImage();
                                          //print('image file : ${imageFile.path}');
                                          ///read the file asynchronously as the image can be very large which may cause blocking of main thread
                                          String base64Image = base64Encode(
                                              await imageFile.readAsBytes());

                                          Map<String, dynamic> map = {
                                            'type': 'image',
                                            'message': base64Image,
                                            'status': 'not seen',
                                            'from': '${currentUser.uid}',
                                            'timestamp':
                                                '${Timestamp.now().seconds}'
                                          };

                                          ///create chat room for current user
                                          _database.createChatRoom(
                                              currentUser.uid, chatUser, map);

                                          ///create chat room for chat user
                                          _database.createChatRoom(
                                              chatUser, currentUser.uid, map);

                                          ///update friend list for current user
                                          _database.createFriend(
                                              currentUser.uid,
                                              chatUser,
                                              'photo');

                                          ///update friend list for chat user
                                          _database.createFriend(chatUser,
                                              currentUser.uid, 'photo');
                                          print(
                                              'current uid ${currentUser.uid}   chat uid : $chatUser');
                                          listScrollController.animateTo(0.0,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeOut);
                                        },
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _messageController,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: null,
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16.0),
                                    decoration: InputDecoration(
                                      hintText: 'Message...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
//                    onChanged: (val) => setState(() => message = val),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> map = {
                                      'type': 'message',
                                      'message': _messageController.text,
                                      'status': 'not seen',
                                      'from': '${currentUser.uid}',
                                      'timestamp': '${Timestamp.now().seconds}'
                                    };

                                    print('${_messageController.text}');

                                    ///create chat room for current user
                                    _database.createChatRoom(
                                        currentUser.uid, chatUser, map);

                                    ///create chat room for chat user
                                    _database.createChatRoom(
                                        chatUser, currentUser.uid, map);

                                    ///update chat friend list for current user
                                    _database.createFriend(currentUser.uid,
                                        chatUser, _messageController.text);

                                    ///update chat friend list for chat user
                                    _database.createFriend(
                                        chatUser,
                                        currentUser.uid,
                                        _messageController.text);
                                    print(
                                        'current uid ${currentUser.uid}   chat uid : $chatUser');
                                    listScrollController.animateTo(0.0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut);

                                    _database.sendNotification(
                                        token: widget.friend.token,
                                        title: 'new message',
                                        body: _messageController.text,
                                        map: widget.myProfile.toJson(),
                                        status: 'message');
                                    _messageController.clear();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.send,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
//           ValueListenableBuilder(
//               valueListenable: canMessageNotifier,
//               builder: (context, val, _) {
//
//                 print(val);
//
//                 return Visibility(
//                   visible: val,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                     decoration: BoxDecoration(
//                         color: Colors.black12,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),
//                             topRight: Radius.circular(10.0))),
//                     child: Row(
//                       children: <Widget>[
//                         Container(
//                           margin: const EdgeInsets.only(right: 16.0),
//                           child: Material(
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 1.0),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.image,
//                                   color: Colors.grey,
//                                 ),
//                                 onPressed: () async {
//                                   imageFile = await ChatCommon.getImage();
//                                   //print('image file : ${imageFile.path}');
//                                   ///read the file asynchronously as the image can be very large which may cause blocking of main thread
//                                   String base64Image =
//                                       base64Encode(await imageFile.readAsBytes());
//
//                                   Map<String, dynamic> map = {
//                                     'type': 'image',
//                                     'message': base64Image,
//                                     'status': 'not seen',
//                                     'from': '${currentUser.uid}',
//                                     'timestamp': '${Timestamp.now().seconds}'
//                                   };
//
//                                   ///create chat room for current user
//                                   _database.createChatRoom(
//                                       currentUser.uid, chatUser, map);
//
//                                   ///create chat room for chat user
//                                   _database.createChatRoom(
//                                       chatUser, currentUser.uid, map);
//
//                                   ///update friend list for current user
//                                   _database.createFriend(
//                                       currentUser.uid, chatUser, 'photo');
//
//                                   ///update friend list for chat user
//                                   _database.createFriend(
//                                       chatUser, currentUser.uid, 'photo');
//                                   print(
//                                       'current uid ${currentUser.uid}   chat uid : $chatUser');
//                                   listScrollController.animateTo(0.0,
//                                       duration: Duration(milliseconds: 300),
//                                       curve: Curves.easeOut);
//                                 },
//                                 color: Colors.white,
//                               ),
//                             ),
//                             color: Colors.transparent,
//                           ),
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             controller: _messageController,
//                             keyboardType: TextInputType.multiline,
//                             textInputAction: TextInputAction.newline,
//                             maxLines: null,
//                             style: TextStyle(color: Colors.blue, fontSize: 16.0),
//                             decoration: InputDecoration(
//                               hintText: 'Message...',
//                               hintStyle: TextStyle(color: Colors.grey),
//                               border: InputBorder.none,
//                             ),
// //                    onChanged: (val) => setState(() => message = val),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Map<String, dynamic> map = {
//                               'type': 'message',
//                               'message': _messageController.text,
//                               'status': 'not seen',
//                               'from': '${currentUser.uid}',
//                               'timestamp': '${Timestamp.now().seconds}'
//                             };
//
//                             print('${_messageController.text}');
//
//                             ///create chat room for current user
//                             _database.createChatRoom(
//                                 currentUser.uid, chatUser, map);
//
//                             ///create chat room for chat user
//                             _database.createChatRoom(
//                                 chatUser, currentUser.uid, map);
//
//                             ///update chat friend list for current user
//                             _database.createFriend(currentUser.uid, chatUser,
//                                 _messageController.text);
//
//                             ///update chat friend list for chat user
//                             _database.createFriend(chatUser, currentUser.uid,
//                                 _messageController.text);
//                             print(
//                                 'current uid ${currentUser.uid}   chat uid : $chatUser');
//                             listScrollController.animateTo(0.0,
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.easeOut);
//
//                             _database.sendNotification(
//                                 token: widget.friend.token,
//                                 title: 'new message',
//                                 body: _messageController.text,
//                                 map: widget.myProfile.toJson(),
//                                 status: 'message');
//                             _messageController.clear();
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(2.0),
//                             child: CircleAvatar(
//                                 radius: 25.0,
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Icons.send,
//                                   color: Theme.of(context).primaryColor,
//                                 )),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
        ],
      ),
    );
  }
}
