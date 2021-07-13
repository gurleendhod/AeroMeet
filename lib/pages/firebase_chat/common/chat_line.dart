import 'dart:convert';

import 'package:aero_meet/pages/firebase_chat/modal/message.dart';
import 'package:flutter/material.dart';
class ChatLine extends StatelessWidget {

  final Message message;
  final currentUser;


  ChatLine({this.message,this.currentUser});

  @override
  Widget build(BuildContext context) {
    if (currentUser == message.from) {
      return Row(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          message.type =='call' || message.type =='call_end' || message.type =='audio_call'?
          Container(
            padding: EdgeInsets.all(24.0),
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${message.message}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                Icon(Icons.call_made, color: Colors.red),
              ],
            ),
          ) : message.type =='image'? Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                  base64Decode(message.message),
                  scale: 5,
                  height: 200,
                fit: BoxFit.contain,
                ),
            ),
          ):message.message.length < 30
              ? Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(8)),
            ),
            child: Text('${message.message}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
          ) : Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(8)),
              ),
              child: Text('${message.message}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          message.type =='call'|| message.type =='call_end' || message.type =='audio_call' ?
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[200],
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('${message.message}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                Icon(Icons.call_made, color: Colors.red),
              ],
            ),
          ) : message.type =='image'? Image.memory(
              base64Decode(message.message),
              scale: 5,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            ): message.message.length < 30
              ? Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(8)),
            ),
            child: Text('${message.message}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
          )
              : Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(right: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(8)),
              ),
              child: Text(
                '${message.message}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }
  }
}
