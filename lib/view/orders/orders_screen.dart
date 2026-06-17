import 'package:flutter/material.dart';
import 'package:ordms/view/orders/create_order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("ord")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOrder()),
          );
        },
        icon: Icon(Icons.add, color: Colors.white,),
        label: Text("Create Order"),
      ),
    );
  }
}