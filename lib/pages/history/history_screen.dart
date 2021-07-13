import 'package:aero_meet/main.dart';
import 'package:aero_meet/pages/dashboard/host_item.dart';
import 'package:aero_meet/pages/dashboard/host_service/host_service.dart';
import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'edit_history.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Box<HostModel> hostBox;
  HostService hostService;

  @override
  void initState() {
    super.initState();
    //initial hive
    hostBox = Hive.box<HostModel>(hostBoxName);
  }

  @override
  Widget build(BuildContext context) {
    hostService = Provider.of<HostService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: hostBox.listenable(),
              builder: (context, Box<HostModel> hosts, _) {
                List<int> keys = hosts.keys.cast<int>().toList();

                if (keys.length < 1) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Empty History',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final int key = keys[keys.length - index - 1];
                    HostModel host = hostBox.get(key);

                    return Host_item(
                      host: host,
                      deleteCallBack: () {
                        print('$key');
                        hostService.deleteHostData(host).then((value) {
                          print(value);
                          hostBox.delete(key);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Room Deleted',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        });
                      },
                      editCallBack: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditHistory(
                                      position: key,
                                      host: host,
                                    )));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
