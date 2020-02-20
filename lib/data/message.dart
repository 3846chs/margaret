import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';

class Message {
  String idFrom;
  String idTo;
  String content;
  String timestamp;
  bool isRead;
  DocumentReference reference;

  Message({this.idFrom, this.idTo, this.content, this.timestamp, this.isRead});

  Message.fromMap(Map<String, dynamic> map, {this.reference}) {
    idFrom = map[MessageKeys.KEY_IDFROM];
    idTo = map[MessageKeys.KEY_IDTO];
    content = map[MessageKeys.KEY_CONTENT];
    timestamp = map[MessageKeys.KEY_TIMESTAMP];
    isRead = map[MessageKeys.KEY_ISREAD];
  }

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        MessageKeys.KEY_IDFROM: idFrom,
        MessageKeys.KEY_IDTO: idTo,
        MessageKeys.KEY_CONTENT: content,
        MessageKeys.KEY_TIMESTAMP: timestamp,
        MessageKeys.KEY_ISREAD: isRead,
      };
}
