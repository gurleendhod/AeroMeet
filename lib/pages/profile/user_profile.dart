import 'package:aero_meet/constant/app_config.dart';
import 'package:aero_meet/constant/custom_styles.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/auth.dart';
import 'package:aero_meet/pages/profile/user_info_card.dart';
import 'package:aero_meet/pages/profile/user_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ChatProfile profile = Provider.of<ChatProfile>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
        child: profile != null ? ListView(
          children: <Widget>[
             userInfoCard(profile,context),
             userStatusCard(profile,context),
            _renderPersonalMeetingCard(profile,context),
            logoutSection(context),
          ],
        ):Container(),
      ),
    );
  }
  Widget _renderPersonalMeetingCard(ChatProfile profile,context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 25.0, bottom: 25.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Personal Identity ID', style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 30.0),
              Container(
                height: 44.0,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  border: Border.all(color: CustomStyles.lightColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('${profile.identity}', style: Theme.of(context).textTheme.headline1,),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Clipboard.setData(new ClipboardData(
                                text: '${profile.identity}'))
                                .then((_) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Personal Identity Code Copied',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            });
                          },
                          child: Icon(
                            Icons.content_copy,
                            color: CustomColors().mainColor(1),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: CustomStyles.boxShadow,
          color: Colors.white,
        ),
      );
  }
  Widget logoutSection(context) {

    ChatAuth _auth = ChatAuth();

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: (){
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content:  Text('Do you want to logout?',style: Theme.of(context).textTheme.headline4,),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                  actionsPadding: EdgeInsets.only(right: 15.0),
                  actions: <Widget>[
                    FlatButton(onPressed: ()async{
                      await _auth.signOut().then((value) => Navigator.pop(context));
                    }, child: Text('Yes',style: Theme.of(context).textTheme.headline5)),
                    FlatButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('No',style: Theme.of(context).textTheme.headline5)),
                  ],
                );
              }
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 0.0, horizontal: 10),
            title: Center(child: Text('Logout', style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),)),
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: CustomStyles.boxShadow,
            color: Colors.white,
            gradient: CustomStyles.primaryGradient,
          ),
        ),
      ),
    );
  }
}
