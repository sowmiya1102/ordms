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

  Future<CreateOrderModel> getOrder(String id) async {
    final response = await _firestore.collection('orders').doc(id).get();
    
    return CreateOrderModel.fromJson(response.data()!);
  }

  Future<List<CreateOrderModel>> getOrders() async {
    final response = await _firestore.collection('orders').get();

    return response.docs
        .map((doc) => CreateOrderModel.fromJson(doc.data()))
        .toList();
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
        .update({'status': -1});
  }

  Future<void> updateOrderStatus(String id, String ordStatus) async {
    await _firestore
        .collection('orders')
        .doc(id)
        .update({'ordStatus': ordStatus});
  }
}