class ChatFriendList{
  final uid;
  final timeStamp;
  final message;

  ChatFriendList({this.uid, this.timeStamp,this.message});

  factory ChatFriendList.fromJson(Map<String,dynamic> item){
    return ChatFriendList(
      uid: item['uid'] ?? '',
      timeStamp: item['timeStamp'] ?? '',
      message: item['message'] ?? '',
    );
  }

}