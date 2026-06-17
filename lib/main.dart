import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordms/view/auth/signup_screen.dart';
import 'package:ordms/view/home/home_screen.dart';
import 'package:ordms/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMedha ORDMS',
      debugShowCheckedModeBanner: false,
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel())
      ],
      child: Consumer<AuthViewModel>(
          builder: (context, authVM, child) {
            return authVM.isAuthenticated
            ? HomeScreen()
            : SignupScreen();
          },
        ),
      ),
    );
  }
}