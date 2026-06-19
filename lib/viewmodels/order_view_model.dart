import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/data/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();

  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isLoading4 = false;
  bool isSearch = false;

  List<String> categories = ["Pending", "Completed", "Cancelled", "All"];
  List<CreateOrderModel> orderList = [];
  List<CreateOrderModel> orderFilterList = [];

  CreateOrderModel? orderData;
  int selectedIndex = 0;
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();

  int get totalOrders => orderList.length;
  int get pendingOrders => orderList.where((e) => e.status == "Pending").length;
  int get completedOrders => orderList.where((e) => e.status == "Completed").length;
  int get cancelledOrders => orderList.where((e) => e.status == "Cancelled").length;
  List<CreateOrderModel> get recentOrders => [...orderList].reversed.take(5).toList();

  List<CreateOrderModel> get todayOrders {
    final today = DateTime.now();

    return orderList.where((order) {
      final date = DateTime.parse(order.eventDate).toLocal();

      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();
  }

  Future<bool> createOrder({
    required String orderItem,
    required String itemName,
    required int quantity,
    required String ordStatus,
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
        ordStatus: ordStatus,
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

  Future<bool> getOrdersList() async {
    try {
      isLoading1 = true;
      notifyListeners();

      final orders = await _repository.getOrders();

      orderList = orders.where((order) => order.status == 1).toList();
      orderFilterList = List.from(orderList);

      print("order list data: $orderList");
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading1 = false;
      notifyListeners();
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      isLoading2 = true;
      notifyListeners();

      await _repository.deleteOrder(id);
      await getOrdersList();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }

  Future<bool> getOrderById(String id) async {
    try{
      isLoading3 = true;
      notifyListeners();

      final resp = await _repository.getOrder(id);
      orderData = resp;
      print("order data by id : $orderData");
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading3 = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrder({
    required String id,
    required String orderItem,
    required String itemName,
    required int quantity,
    required String ordStatus,
    required String customerName,
    required String phone,
    required String location,
    required String eventDate,
    required String eventTime,
    required String notes,
    required int status,
  }) async {
    try {
      isLoading4 = true;
      notifyListeners();

      final order = CreateOrderModel(
        id: id,
        orderItem: orderItem,
        itemName: itemName,
        quantity: quantity,
        ordStatus: ordStatus,
        customerName: customerName,
        phone: phone,
        location: location,
        eventDate: eventDate,
        eventTime: eventTime,
        notes: notes,
        createdAt: orderData!.createdAt, // keep old created time
        status: status,
      );

      await _repository.updateOrder(order);

      await getOrdersList();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading4 = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;

    if (category == "All") {
      orderFilterList = List.from(orderList);
    } else {
      orderFilterList = orderList.where((order) {
        return order.orderItem.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    notifyListeners();
  }

  void selectStatus(int index) {
    selectedIndex = index;
    filterOrder();
  }

  void filterOrder() {
    String search = searchController.text.toLowerCase();

    orderFilterList = orderList.where((e) {

      // Status Filter
      bool statusMatch = true;

      if (selectedIndex == 0) {
        statusMatch = e.ordStatus.toLowerCase() == "pending";
      } else if (selectedIndex == 1) {
        statusMatch = e.ordStatus.toLowerCase() == "completed";
      } else if (selectedIndex == 2) {
        statusMatch = e.ordStatus.toLowerCase() == "cancelled";
      }

      // Item Dropdown Filter
      bool categoryMatch = selectedCategory == "All"
          ? true
          : e.orderItem == selectedCategory;

      // Search
      bool searchMatch =
          search.isEmpty ||
          e.itemName.toLowerCase().contains(search) ||
          e.customerName.toLowerCase().contains(search) ||
          e.eventDate.toLowerCase().contains(search);

      return statusMatch && categoryMatch && searchMatch;
    }).toList();

    notifyListeners();
  }
}