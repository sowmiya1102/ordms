import 'package:flutter/material.dart';
import 'package:ordms/view/dashboard/dashboard_screen.dart';
import 'package:ordms/view/orders/orders_screen.dart';
import 'package:ordms/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Widget> _screens = [ 
    // CustomersScreen(),
    DashboardScreen(),
    const OrdersScreen(),
    const Text("customers")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (_, homeVM, __) {
            return SafeArea(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _screens[homeVM.bottomNavIndex],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<HomeViewModel>(
        builder: (context, homeVM, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: homeVM.bottomNavIndex,
              onTap: (index) {
                homeVM.changeBottomTab(index);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              elevation: 0,
              enableFeedback: true,
              selectedFontSize: 13,
              unselectedFontSize: 12,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long),
                  label: "Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: "Customers",
                ),
              ],
            )
          );
        })
    );
  }
}