import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/data/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();

  bool isLoading = false;

  Future<bool> createOrder({
    required String orderItem,
    required String itemName,
    required int quantity,
    required String customerName,
    required String phone,
    required String location,
    required String eventDate,
    required String eventTime,
    required String notes,
    required int status
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final doc = FirebaseFirestore.instance.collection("orders").doc();

      CreateOrderModel order = CreateOrderModel(
        id: doc.id,
        orderItem: orderItem,
        itemName: itemName,
        quantity: quantity,
        customerName: customerName,
        phone: phone,
        location: location,
        eventDate: eventDate,
        eventTime: eventTime,
        notes: notes,
        createdAt: DateTime.now(),
        status: status
      );

      await _repository.createOrder(order);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}