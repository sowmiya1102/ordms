import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordms/data/models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateSubscription({
    required String uid,
    required bool isSubscribed,
  }) async {
    await _db.collection('users').doc(uid).update({
      'isSubscribed': isSubscribed,
    });
  }
}