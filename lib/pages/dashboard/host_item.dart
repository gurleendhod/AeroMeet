import 'package:aero_meet/constant/app_config.dart';
import 'package:aero_meet/constant/custom_styles.dart';
import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Host_item extends StatelessWidget {
  final HostModel host;
  final VoidCallback deleteCallBack;
  final VoidCallback editCallBack;

  Host_item({this.host, this.deleteCallBack, this.editCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: CustomStyles.boxShadow,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 8, top: 4),
                    child: Text(
                      'Title : ${host.title}',
                      maxLines: 1,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Room ID : ${host.channelID}",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                      text: '${host.channelID}'))
                                  .then((_) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Room Code Copied',
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
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Meeting scheduled on ${host.date} at ${host.time}",
                          style: Theme.of(context).textTheme.subtitle2,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            flex: 100,
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  deleteCallBack();
                },
                child: Container(
                  width: 30,
                  height: 24,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 8),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Theme.of(context).primaryColor),
                ),
              ),
              GestureDetector(
                onTap: editCallBack,
                child: Container(
                  width: 30,
                  height: 24,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 8),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
