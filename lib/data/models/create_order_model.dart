import 'package:hive/hive.dart';

part 'create_order_model.g.dart'; // ← required for code generation

@HiveType(typeId: 0)
class CreateOrderModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderItem;

  @HiveField(2)
  final String itemName;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String ordStatus;

  @HiveField(5)
  final String customerName;

  @HiveField(6)
  final String phone;

  @HiveField(7)
  final String location;

  @HiveField(8)
  final String eventDate;

  @HiveField(9)
  final String eventTime;

  @HiveField(10)
  final String notes;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final int status;

  CreateOrderModel({
    required this.id,
    required this.orderItem,
    required this.itemName,
    required this.quantity,
    required this.ordStatus,
    required this.customerName,
    required this.phone,
    required this.location,
    required this.eventDate,
    required this.eventTime,
    required this.notes,
    required this.createdAt,
    required this.status,
  });

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderModel(
      id: json['id'] ?? '',
      orderItem: json['orderItem'] ?? '',
      itemName: json['itemName'] ?? '',
      quantity: json['quantity'] ?? 0,
      ordStatus: json['ordStatus'] ?? '',
      customerName: json['customerName'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventTime: json['eventTime'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderItem': orderItem,
      'itemName': itemName,
      'quantity': quantity,
      'ordStatus': ordStatus,
      'customerName': customerName,
      'phone': phone,
      'location': location,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}