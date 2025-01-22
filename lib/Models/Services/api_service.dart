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

  switch (response.statusCode) {
    case 200: // OK
      return json.decode(response.body); // Parse JSON response
    case 400: // Bad Request
      throw Exception('Bad Request: Check the request parameters.');
    case 401: // Unauthorized
      throw Exception('Unauthorized: Invalid username or password.');
    case 403: // Forbidden
      throw Exception('Forbidden: You do not have access to this resource.');
    case 404: // Not Found
      throw Exception('Not Found: The API endpoint does not exist.');
    case 500: // Internal Server Error
      throw Exception('Internal Server Error: Please try again later.');
    case 503: // Service Unavailable
      throw Exception('Service Unavailable: The server is currently unreachable.');
    default: // Other unhandled status codes
      throw Exception('Error: ${response.statusCode} - ${response.body}');
  }
}

}
