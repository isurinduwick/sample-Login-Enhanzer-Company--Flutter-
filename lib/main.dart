import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enhanzer Sample Login',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/success': (context) => const SuccessScreen(),
      },
    );
  }
}