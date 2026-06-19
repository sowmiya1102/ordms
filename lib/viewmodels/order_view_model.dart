import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/data/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository = OrderRepository();
  final Box<CreateOrderModel> orderBox = Hive.box<CreateOrderModel>('orders');

  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  bool isLoading4 = false;
  bool isLoading5 = false;
  bool isSearch = false;
  bool isOffline = false;

  List<String> categories = ["Pending", "Completed", "Cancelled", "All"];
  List<CreateOrderModel> orderList = [];
  List<CreateOrderModel> orderFilterList = [];

  CreateOrderModel? orderData;
  int selectedIndex = 0;
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();

  int get totalOrders => orderList.length;
  int get pendingOrders => orderList.where((e) => e.ordStatus.toLowerCase() == "pending").length;
  int get completedOrders => orderList.where((e) => e.ordStatus.toLowerCase() == "completed").length;
  int get cancelledOrders => orderList.where((e) => e.ordStatus.toLowerCase() == "cancelled").length;
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

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Map<String, int> get popularItems {
    final Map<String, int> data = {};

    for (var order in orderList) {
      final key = order.orderItem.trim();

      data[key] = (data[key] ?? 0) + 1;
    }

    return data;
  }

  List<Map<String, dynamic>> get popularItemsChart {
    final items = popularItems.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return items.map((e) {
      return {
        "item": e.key,
        "count": e.value,
      };
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

      final online = await isOnline();

      if (online) {
        final remoteOrders = await _repository.getOrders();

        orderList = remoteOrders.where((o) => o.status == 1).toList();
        orderFilterList = List.from(orderList);

        isOffline = false;

        for (var order in orderList) {
          orderBox.put(order.id, order);
        }
      } else {
        orderList = orderBox.values.toList();
        orderFilterList = List.from(orderList);
        isOffline = true;
      }

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

  Future<bool> orderStatusUpdate(String id, String ordStatus) async {
    try {
      isLoading5 = true;
      notifyListeners();

      await _repository.updateOrderStatus(id, ordStatus);
      await getOrdersList();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading5 = false;
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