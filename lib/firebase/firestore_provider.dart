import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/transformer.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> attemptCreateUser(User user) {
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(user.userKey);
    print(userRef.path);
    return _firestore.runTransaction((Transaction tx) async {
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
}

FirestoreProvider firestoreProvider = FirestoreProvider();
