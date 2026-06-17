import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordms/data/models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _db.collection('users')
    .doc(user.uid)
    .set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> updatePickStatus({
    required String uid,
    required String role,
    required List<String> needs,
  }) async {
    await _db.collection('users').doc(uid).update({
      'role': role,
      'needs': needs,
    });
  }
}