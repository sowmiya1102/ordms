import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ordms/data/models/create_order_model.dart';
import 'package:ordms/view/auth/signup_screen.dart';
import 'package:ordms/view/home/home_screen.dart';
import 'package:ordms/viewmodels/auth_view_model.dart';
import 'package:ordms/viewmodels/home_view_model.dart';
import 'package:ordms/viewmodels/order_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(CreateOrderModelAdapter());
  await Hive.openBox<CreateOrderModel>('orders');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MaterialApp(
        title: 'IMedha ORDMS',
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthViewModel>(
          builder: (context, authVM, child) {
            // return HomeScreen();
            return authVM.isAuthenticated ? HomeScreen() : SignupScreen();
          },
        ),
      ),
    );
  }
}