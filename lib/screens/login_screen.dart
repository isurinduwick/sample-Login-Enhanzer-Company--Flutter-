import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';
import 'success_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    //loading indicate
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Call Api
      final response = await ApiService.login(username, password);
      print('Login response: $response');

      if (response['Status_Code'] == 200) {
        // Get the API data form the document Enhanzer company provide
        final userData = response['Response_Body'][0];
        final user = {
          'userCode': userData['EZCMP1/EZUSR-1'],
          'displayName': userData['eZuite Admin'],
          'email': userData['info@enhanzer.com'],
          'User_Employee_Code': userData['EZCMP1/EZLOC2/EMP-7'],
          'Company_Code': userData['EZCMP-1'],
          'User_Locations': userData['userLocations'],
          'User_Permissions': userData['userPermissions'],
        };

        // Save the data to Database
        await DBService.instance.saveUser(user);

        // Navigate to Success Screen login is Successfully
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Login failed: ${response['Message']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

                // Company logo
                Center(
                  child: Image.asset(
                    "assets/Enhanzer logo.jpg",
                    height: 100,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login in to continue.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  maxLength: 40, //Valitade the Length of UserName
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

                  //User Name Filed Validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  maxLength: 30, //Valitade the Length of Password
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

                  //Password Filed Validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
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
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
