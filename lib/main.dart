import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/success_screen.dart';

void main() async {
  // Ensure all platform plugins are initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the login state from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enhanzer Sample Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Start with the appropriate screen based on the login state
      home: isLoggedIn ? const SuccessScreen() : const LoginScreen(),
    );
  }
}
