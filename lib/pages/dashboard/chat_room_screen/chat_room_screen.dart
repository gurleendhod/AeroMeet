import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/join_room_screen_bloc.dart';


class JoinRoomScreen extends StatelessWidget {

  final  name;
  final HostModel host;

  const JoinRoomScreen({this.name,this.host,Key key}) : super(key: key);

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
  void _onToggleMute(BuildContext context) {
    BlocProvider.of<JoinRoomScreenBloc>(context).add(ToggleMute());
  }
  void _onSwitchCamera(BuildContext context) {
    BlocProvider.of<JoinRoomScreenBloc>(context).add(SwitchCamera());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoinRoomScreenBloc,JoinRoomScreenState>(
      builder: (BuildContext context, JoinRoomScreenState state){
        return _buildWidget(context, state);
      }
    );
  }

  Widget _buildWidget(BuildContext context, JoinRoomScreenState state){
    return Scaffold(
      appBar: AppBar(
        title: Text('${host.title}'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: state.loading ? CircularProgressIndicator() : Stack(
          children: <Widget>[
            _viewRows(context, state),
//            _panel(context, state),
            _toolbar(context, state),
          ],
        ),
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(BuildContext context, JoinRoomScreenState state) {
    final views = _getRenderViews(context, state);
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar(BuildContext context, JoinRoomScreenState state) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(context),
            child: Icon(
              state.muted ? Icons.mic_off : Icons.mic,
              color: state.muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: state.muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchCamera(context),
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews(BuildContext context, JoinRoomScreenState state) {
    final List<SurfaceView> list = [
      SurfaceView(),
    ];
    state.users.forEach((int uid) => list.add(SurfaceView()));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }
}
