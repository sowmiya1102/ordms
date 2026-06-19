import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ordms/data/services/razorpay_service.dart';
import 'package:ordms/viewmodels/order_view_model.dart';
import 'package:provider/provider.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final RazorpayService razorpayService = RazorpayService();

  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();

    razorpayService.init();

    _loadSubscription();

    razorpayService.onSuccess = (paymentId) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'isSubscribed': true,
      });

      setState(() {
        isSubscribed = true;
      });
    };
  }

  Future<void> _loadSubscription() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      isSubscribed = doc.data()?['isSubscribed'] ?? false;
    });
  }

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Insights",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<OrderViewModel>(
        builder: (context, vm, child) {
          final data = vm.popularItemsChart;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Popular Order Items",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (data.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text("No data available"),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final item = data[index];

                                return _barRow(
                                  item["item"],
                                  item["count"],
                                  Colors.blue,
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    if (!isSubscribed)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(
                              color: Colors.white.withOpacity(0.4),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.lock, size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    "Subscribe to unlock insights",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                if (!isSubscribed)
                  ElevatedButton(
                    onPressed: () {
                      razorpayService.openCheckout(
                        amount: 99,
                        name: "Insights Subscription",
                        description: "Unlock analytics & insights",
                      );
                    },
                    child: const Text("Subscribe Now ₹99"),
                  )
                else
                  const Text(
                    "You are subscribed 🎉",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _barRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (value / 20).clamp(0.0, 1.0),
                color: color,
                backgroundColor: Colors.grey.shade300,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}