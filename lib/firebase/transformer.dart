import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/user.dart';

class Transformer {
  final toUser = StreamTransformer<DocumentSnapshot, User>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(User.fromSnapshot(snapshot));
  });

  final toUsers = StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
      handleData: (snapshot, sink) {
    List<User> users = [];
    snapshot.documents.forEach((doc) {
      users.add(User.fromSnapshot(doc));
    });
    sink.add(users);
  });

  final toMessage = StreamTransformer<DocumentSnapshot, Message>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(Message.fromSnapshot(snapshot));
  });

  final toMessages =
      StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<Message> messages = [];
    snapshot.documents.forEach((doc) {
      messages.add(Message.fromSnapshot(doc));
    });
    sink.add(messages);
  });
}
