import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firestore/transformer.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> attemptCreateUser({String userKey, String email}) {
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(userKey);
    print(userRef.path);
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        await tx.update(userRef, snapshot.data);
        print('tx update completed');
      } else {
        await tx.set(userRef, User.getMapForCreateUser(email));
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