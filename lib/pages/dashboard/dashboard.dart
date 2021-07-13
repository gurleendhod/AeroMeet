import 'package:aero_meet/constant/custom_styles.dart';
import 'package:aero_meet/constant/text_field_style.dart';
import 'package:aero_meet/pages/dashboard/chat_room_screen/videochat_room_screen.dart';
import 'package:aero_meet/pages/dashboard/host_service/host_service.dart';
import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:aero_meet/pages/firebase_chat/modal/chat_friend.dart';
import 'package:aero_meet/pages/firebase_chat/services/database.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'chat_room_screen/bloc/join_room_screen_bloc.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPageIndex = 0;
  String _roomID;
  String _name;
  String _title;
  String _channelHostID;
  String _time;
  HostService hostService;
  final _formKey = GlobalKey<FormState>();
  Box<HostModel> hostBox;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _channelController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  List<HostModel> hosts;
  DateTime date = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  DateFormat timeFormatter = DateFormat('HH:mm');
  String token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    hostBox = Hive.box<HostModel>(hostBoxName);
    _dateController.text = formatter.format(DateTime.now());
    _timeController.text = timeFormatter.format(DateTime.now());
    _firebaseMessaging.getToken().then((value) {
      print('token is $value');
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    hostService = Provider.of<HostService>(context);
    hosts = Provider.of<List<HostModel>>(context);
    final profile = Provider.of<ChatProfile>(context);

    if (profile != null) {
      ChatDatabase().updateUserToken(token: token, uid: profile.uid);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('AeroMeet'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: selectedPageIndex == 0
              ? ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    _buildRegionTabBar(),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Room ID'),
                      validator: (val) => val.isEmpty ? 'Enter Room ID' : null,
                      onChanged: (val) {
                        setState(() {
                          _roomID = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Display Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter Display Name' : null,
                      onChanged: (val) {
                        setState(() {
                          _name = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Join Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onJoin,
                    ),
                  ],
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    _buildRegionTabBar(),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      controller: _titleController,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Meeting Title'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter Meeting Title' : null,
                      onChanged: (val) {
                        setState(() {
                          _title = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      controller: _channelController,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Create a Room ID'),
                      validator: (val) => val.isEmpty ? 'Enter Room ID' : null,
                      onChanged: (val) {
                        setState(() {
                          _channelHostID = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      controller: _dateController,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Meeting Date'),
                      readOnly: true,
                      validator: (val) =>
                          val.isEmpty ? 'Enter Meeting Date' : null,
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          setState(() {
                            _dateController.text = formatter.format(date);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      controller: _timeController,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Meeting Time'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter Meeting Time' : null,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showTimePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true, onConfirm: (time) {
                          setState(() {
                            _timeController.text = timeFormatter.format(time);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Create Room',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onRoomCreate,
                    ),
                  ],
                ),
        ),
      ),
      // bottomNavigationBar: AdmobWidget(),
    );
  }

  Future<void> onRoomCreate() async {
    if (_formKey.currentState.validate()) {
      final host = HostModel(
          title: _title,
          channelID: _channelHostID,
          date: _dateController.text,
          time: _timeController.text);
      hostService.addHostData(host).then((value) {
        Scaffold.of(_formKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(
              'Room Created',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        hostBox.add(host);
        _titleController.clear();
        _channelController.clear();
        _dateController.clear();
        _timeController.clear();
      }).catchError((e) {
        Scaffold.of(_formKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(
              '${e.toString()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    }
  }

  Future<void> onJoin() async {
    if (_formKey.currentState.validate()) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();

      List<HostModel> filteredHostList =
          hosts.where((host) => host.channelID == _roomID).toList();

      if (filteredHostList.length == 0) {
        Scaffold.of(_formKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(
              'No room found with $_roomID',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        print(filteredHostList.elementAt(0).channelID);
        if (filteredHostList.elementAt(0).channelID == _roomID) {
          // push video page with given channel name
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider<JoinRoomScreenBloc>(
                      create: (BuildContext c) => JoinRoomScreenBloc(_roomID),
                      child: JoinRoomScreen(
                        name: _name,
                        host: filteredHostList.elementAt(0),
                      ),
                    )),
          );
        }
      }
    }
  }

  Future<void> _handleCameraAndMic() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (!status[Permission.microphone].isGranted) {
      await Permission.microphone.request();
    } else if (!status[Permission.camera].isGranted) {
      await Permission.camera.request();
    }
  }

  Widget _buildRegionTabBar() {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.blue,
            ),
            labelStyle: CustomStyles.tabTextStyle,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue,
            tabs: <Widget>[
              Text('Join Meeting'),
              Text('Host Meeting'),
            ],
            onTap: (index) {
              setState(() {
                selectedPageIndex = index;
              });
              print(index);
            },
          ),
        ),
      ),
    );
  }
}
