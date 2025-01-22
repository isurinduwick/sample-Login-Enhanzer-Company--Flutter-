import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke';

  /// Sends login request to the API
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final requestBody = {
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": "GetUserData",
      "Company_Code": username,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );
    //print("header----------"); 
    //print(response.headers);  
    // print("header----------");   // Print response headers
   
     //print("body" + response.body); 
   
    


    if (response.statusCode == 200) {
      return json.decode(response.body); // Parse JSON response
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}
