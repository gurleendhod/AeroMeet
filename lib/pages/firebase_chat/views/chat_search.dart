import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/views/search_list.dart';
import 'package:aero_meet/pages/firebase_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatSearchScreen extends StatefulWidget {
  final ChatProfile myProfile;

  ChatSearchScreen({this.myProfile});

  @override
  _ChatSearchScreenState createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  bool isSearching = false;
  String searchCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context: context, title: 'Search'),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(25.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.blue, fontSize: 18.0),
                      decoration: InputDecoration(
                        hintText: 'Search by Identity Code',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => searchCode = val),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print(searchCode);
                        isSearching = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Container(
              child: SearchFriend(
                code: searchCode,
                myProfile: widget.myProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
