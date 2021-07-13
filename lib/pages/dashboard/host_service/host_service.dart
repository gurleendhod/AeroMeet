import 'package:aero_meet/pages/dashboard/model/host_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostService{

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('host_channel');

  Future addHostData(HostModel hostModel) async{
    return await collectionReference.doc(hostModel.channelID).set(
      {
        'title':hostModel.title,
        'channel_id':hostModel.channelID,
        'date':hostModel.date,
        'time':hostModel.title,
        'published':'${Timestamp.now().seconds}',
      }
    );
  }

  Future deleteHostData(HostModel hostModel) async{
    return await collectionReference.doc(hostModel.channelID).delete();
  }

  Stream<List<HostModel>> get hosts{
    return collectionReference.snapshots().map(getHostListFromSnapshot);
  }

  List<HostModel> getHostListFromSnapshot(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((doc){
      return HostModel.fromJson(doc.data());
    }).toList();
  }

}