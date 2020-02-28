import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/transformer.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> attemptCreateUser(User user) {
    final userRef =
        _firestore.collection(COLLECTION_USERS).document(user.userKey);
    print(userRef.path);
    return _firestore.runTransaction((tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        await tx.update(userRef, snapshot.data);
        print('tx update completed');
      } else {
        await tx.set(userRef, user.toMap());
        print('tx set completed');
      }
    });
  }

  Future<void> updateUser(String userKey, Map<String, dynamic> data) {
    return _firestore
        .collection(COLLECTION_USERS)
        .document(userKey)
        .updateData(data);
  }

  Stream<User> connectUser(String userKey) {
    print('connect called');
    return _firestore
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<List<User>> fetchAllUsers() {
    return _firestore
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsers);
  }

  Future<void> createMessage(String chatKey, Message message) {
    final messageRef = _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .document(message.timestamp);

    return _firestore.runTransaction((tx) async {
      await tx.set(messageRef, message.toMap());
    });
  }

  Future<void> updateMessage(
      String chatKey, String messageKey, Map<String, dynamic> data) {
    return _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .document(messageKey)
        .updateData(data);
  }

  Stream<Message> connectMessage(String chatKey, [String timestamp]) {
    if (timestamp == null) {
      return _firestore
          .collection(COLLECTION_CHATS)
          .document(chatKey)
          .collection(chatKey)
          .orderBy(MessageKeys.KEY_TIMESTAMP, descending: true)
          .limit(1)
          .snapshots()
          .transform(toLastMessage);
    }

    return _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .document(timestamp)
        .snapshots()
        .transform(toMessage);
  }

  Stream<List<Message>> fetchAllMessages(String chatKey) {
    return _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .orderBy(MessageKeys.KEY_TIMESTAMP, descending: true)
        .snapshots()
        .transform(toMessages);
  }
}

FirestoreProvider firestoreProvider = FirestoreProvider();
