class CreateOrderModel {
  final String id;
  final String orderItem;
  final String itemName;
  final int quantity;
  final String customerName;
  final String phone;
  final String location;
  final String eventDate;
  final String eventTime;
  final String notes;
  final DateTime createdAt;
  final int status;

  CreateOrderModel({
    required this.id,
    required this.orderItem,
    required this.itemName,
    required this.quantity,
    required this.customerName,
    required this.phone,
    required this.location,
    required this.eventDate,
    required this.eventTime,
    required this.notes,
    required this.createdAt,
    required this.status
  });

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderModel(
      id: json['id'] ?? '',
      orderItem: json['orderItem'] ?? '',
      itemName: json['itemName'] ?? '',
      quantity: json['quantity'] ?? 0,
      customerName: json['customerName'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventTime: json['eventTime'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderItem': orderItem,
      'itemName': itemName,
      'quantity': quantity,
      'customerName': customerName,
      'phone': phone,
      'location': location,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'status': status
    };
  }
}