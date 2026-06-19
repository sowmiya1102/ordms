

import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/data/services/order_service.dart';

class OrderRepository {
  final OrderService _service = OrderService();

  Future<void> createOrder(CreateOrderModel order) {
    return _service.createOrder(order);
  }

  Future<void> updateOrder(CreateOrderModel order) {
    return _service.updateOrder(order);
  }

  Future<void> deleteOrder(String id) {
    return _service.deleteOrder(id);
  }

  Future<List<CreateOrderModel>> getOrders() {
    return _service.getOrders();
  }

  Future<CreateOrderModel> getOrder(String id) {
    return _service.getOrder(id);
  }
}