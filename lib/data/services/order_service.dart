import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordms/data/models/create_order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder(CreateOrderModel order) async {
    await _firestore
        .collection('orders')
        .doc(order.id)
        .set(order.toJson());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrder(String id) async {
    return await _firestore
        .collection('orders')
        .doc(id)
        .get();
  }

  // Future<List<CreateOrderModel>> getOrders() async {
  //   final snapshot = await _firestore.collection('orders').get();

  //   return snapshot.docs
  //       .map((doc) => CreateOrderModel.fromJson(doc.data()))
  //       .toList();
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrders() async {
    return await _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<void> updateOrder(CreateOrderModel order) async {
    await _firestore
        .collection('orders')
        .doc(order.id)
        .update(order.toJson());
  }

  Future<void> deleteOrder(String id) async {
    await _firestore
        .collection('orders')
        .doc(id)
        .delete();
  }
}