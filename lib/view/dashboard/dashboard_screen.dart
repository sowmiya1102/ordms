import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ordms/view/auth/signup_screen.dart';
import 'package:ordms/viewmodels/auth_view_model.dart';
import 'package:ordms/viewmodels/order_view_model.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final userName = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().getOrdersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              context.read<AuthViewModel>().signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<OrderViewModel>(
          builder: (context, vm, child) {
            if(vm.isLoading1) {
              return Center(child: CircularProgressIndicator(strokeWidth: 1.0,),);
            }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Text(
                "Welcome ${userName!.displayName ?? ''}👋",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
          
              const SizedBox(height: 20),
          
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
          
                  DashboardCard(
                    title: "Total Orders",
                    value: vm.totalOrders.toString(),
                    color: Colors.blue,
                    icon: Icons.shopping_bag,
                  ),
          
                  DashboardCard(
                    title: "Pending",
                    value: vm.pendingOrders.toString(),
                    color: Colors.orange,
                    icon: Icons.pending_actions,
                  ),
          
                  DashboardCard(
                    title: "Completed",
                    value: vm.completedOrders.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
          
                  DashboardCard(
                    title: "Cancelled",
                    value: vm.cancelledOrders.toString(),
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                ],
              ),
          
              const SizedBox(height: 30),
          
              const Text(
                "Today's Orders",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
          
              const SizedBox(height: 10),

              vm.todayOrders.isEmpty ?
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No Orders Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.todayOrders.length,
                itemBuilder: (context, index) {
                  final order = vm.todayOrders[index];
          
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.today,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(order.customerName),
                      subtitle: Text(
                        "${order.quantity} (${order.itemName})",
                      ),
                      trailing: Chip(
                        backgroundColor: order.ordStatus == "pending" ?
                        Colors.amber : order.ordStatus == "completed" ?
                        Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: Text(
                          order.ordStatus,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
          
              const SizedBox(height: 25),
          
              const Text(
                "Recent Orders",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
          
              const SizedBox(height: 10),

              vm.recentOrders.isEmpty ?
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No Orders Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.recentOrders.length,
                itemBuilder: (context, index) {
                  final order = vm.recentOrders[index];
          
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(order.customerName),
                      subtitle: Text(
                        "${order.quantity} (${order.itemName})",
                      ),
                      trailing: Chip(
                        backgroundColor: order.ordStatus == "pending" ?
                        Colors.amber : order.ordStatus == "completed" ?
                        Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: Text(
                          order.ordStatus,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
          }
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
                const SizedBox(width: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}