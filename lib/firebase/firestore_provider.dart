import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/transformer.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> updatePushToken(String userKey, String token) {
    return _firestore
        .collection(COLLECTION_USERS)
        .document(userKey)
        .updateData({UserKeys.KEY_PUSHTOKEN: token});
  }

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

  Stream<User> connectMyUserData(String userKey) {
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
      await tx.set(messageRef, {
        'idFrom': message.idFrom,
        'idTo': message.idTo,
        'timestamp': message.timestamp,
        'content': message.content,
      });
    });
  }

  Stream<Message> connectMessage(String chatKey, String timestamp) {
    return _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .document(timestamp)
        .snapshots()
        .transform(toMessage);
  }

  Stream<Message> connectLastMessage(String chatKey) {
    return _firestore
        .collection(COLLECTION_CHATS)
        .document(chatKey)
        .collection(chatKey)
        .orderBy(MessageKeys.KEY_TIMESTAMP, descending: true)
        .limit(1)
        .snapshots()
        .transform(toLastMessage);
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
