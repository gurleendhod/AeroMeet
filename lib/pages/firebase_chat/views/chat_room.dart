import 'dart:convert';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/modal/friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/auth.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_search.dart';
import 'conversation_screen.dart';

class ChatRoom extends StatefulWidget {
  final ChatProfile myProfile;

  ChatRoom({this.myProfile});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  ChatAuth _auth = ChatAuth();
  //database instance
  ChatDatabase _database = ChatDatabase();

  @override
  Widget build(BuildContext context) {
    //current logged in user
    final currentUser = Provider.of<ChatUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatSearchScreen(
                        myProfile: widget.myProfile,
                      )));
        },
      ),
      body: StreamBuilder<List<ChatFriendList>>(
        stream: _database.getFriend(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                if (currentUser.uid != snapshot.data.elementAt(index).uid) {
                  String chatUser = snapshot.data.elementAt(index).uid;
                  String lastMessage = snapshot.data.elementAt(index).message;

                  ///after retrieving chat uid
                  ///then can access the user profile
                  return StreamBuilder<List<ChatProfile>>(
                    stream: _database.searchUserById(chatUser),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length < 1) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Empty list',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.grey),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            ChatProfile profile =
                                snapshot.data.elementAt(index);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatConversation(
                                              friend: profile,
                                              myProfile: widget.myProfile,
                                            )));
                              },
                              child: Card(
                                elevation: 8,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: profile.image == null ||
                                            profile.image == ''
                                        ? NetworkImage(
                                            'https://cdn4.iconfinder.com/data/icons/user-people-2/48/6-512.png',
                                            scale: 5,
                                          )
                                        : MemoryImage(
                                            base64Decode(profile.image),
                                          ),
                                  ),
                                  title: Text(
                                    '${profile.name}',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  subtitle: Text(
                                    '$lastMessage',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(Icons.message,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return CircleAvatar();
          }
        },
      ),
    );
  }
}
