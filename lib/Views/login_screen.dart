import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/Services/db_service.dart';
import '../Models/Services/api_service.dart';
import '../Views/success_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Username and Password Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Propeties
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              _buildLogo(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 32),
              _buildUsernameField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 32),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    ),
  );
}

// Builds the logo widget
Widget _buildLogo() {
  return Center(
    child: Image.asset(
      "assets/logo.png",
      height: 100,
    ),
  );
}

// Builds the title and subtitle
Widget _buildTitle() {
  return Column(
    children: const [
      Text(
        'Login',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'Log in to continue.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

// Builds the username input field
Widget _buildUsernameField() {
  return TextFormField(
    controller: _usernameController,
    maxLength: 40,
    decoration: InputDecoration(
      labelText: 'USER NAME',
      labelStyle: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.2,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      counterText: '',
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Username cannot be empty';
      }
      return null;
    },
  );
}

// Builds the password input field
Widget _buildPasswordField() {
  return TextFormField(
    controller: _passwordController,
    obscureText: true,
    maxLength: 30,
    decoration: InputDecoration(
      labelText: 'PASSWORD',
      labelStyle: const TextStyle(
        fontSize: 12,
        letterSpacing: 1.2,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      counterText: '',
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Password cannot be empty';
      }
      return null;
    },
  );
}

// Builds the login button
Widget _buildLoginButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A2A56),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Log in',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    ),
  );
}

 //Methods 
  Future<void> _login() async {
  // Validate the form
  if (!_formKey.currentState!.validate()) return;

  // Show loading indicator
  setState(() => _isLoading = true);

  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  try {
    // Call API for login
    final response = await ApiService.login(username, password);

    if (response['Status_Code'] == 200) {
      // Parse user data from the API response
      final userData = response['Response_Body']?.first ?? {};
      final user = _buildUserMap(userData);

      // Save user data to the database
      await DBService.instance.saveUser(user);

      // Save login state
      await _saveLoginState();

      // Display success message
      _displayToast('Login successful: ${response['Message']}');

      // Navigate to Success Screen
      _navigateToSuccessScreen();
    } else {
      // Handle API error response
      _displayToast('Login failed: ${response['Message']}');
    }
  } catch (e) {
    // Handle any errors during login
    _displayToast('Login failed: $e');
  } finally {
    // Hide loading indicator
    setState(() => _isLoading = false);
  }
}

Map<String, dynamic> _buildUserMap(Map<String, dynamic> userData) {
  return {
    'userCode': userData['User_Code'] ?? '',
    'displayName': userData['User_Display_Name'] ?? '',
    'email': userData['Email'] ?? '',
    'User_Employee_Code': userData['User_Employee_Code'] ?? '',
    'Company_Code': userData['Company_Code'] ?? '',
    'User_Locations': json.encode(userData['User_Locations'] ?? []),
    'User_Permissions': json.encode(userData['User_Permissions'] ?? []),
  };
}

Future<void> _saveLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
}

  //Display Toast
  void _displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }

  // Navigate to the success screen
  void _navigateToSuccessScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccessScreen()),
    );
  }
}
