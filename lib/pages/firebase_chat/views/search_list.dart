import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_user.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'conversation_screen.dart';

class SearchFriend extends StatefulWidget {

  final String code;
  final ChatProfile myProfile;

  SearchFriend({this.code,this.myProfile});

  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  @override
  Widget build(BuildContext context) {

    //database instance
    ChatDatabase _database = ChatDatabase();
    //current logged in user
    final currentUser = Provider.of<ChatUser>(context);

    //stream builder for data sync
    return StreamBuilder<List<ChatProfile>>(
      stream: _database.searchUserByName(widget.code),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              if(currentUser.uid != snapshot.data.elementAt(index).uid) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>
                            ChatConversation(
                                friend: snapshot.data.elementAt(index),myProfile: widget.myProfile,)));
                  },
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text('${snapshot.data
                          .elementAt(index)
                          .name}'),
                      subtitle: Text('${snapshot.data
                          .elementAt(index)
                          .email}'),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.message, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }else{
                return Container();
              }
            },
          );
        }else{
          return Container();
        }
      },
    );
  }
}
