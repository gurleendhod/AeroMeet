import 'package:hive/hive.dart';
part 'host_model.g.dart';

@HiveType(typeId: 0)
class HostModel{

  @HiveField(0)
  final title;
  @HiveField(1)
  final channelID;
  @HiveField(2)
  final date;
  @HiveField(3)
  final time;
  @HiveField(4)
  final published;

  HostModel({this.title, this.channelID, this.date, this.time,this.published});

  factory HostModel.fromJson(Map<dynamic,dynamic> json){
    return HostModel(
        title: json['title'],
        channelID: json['channel_id'],
        date: json['date'],
        time: json['time'],
        published: json['published']
    );
  }

}