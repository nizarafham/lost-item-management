import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api/users/";
  final Dio _dio = Dio();

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<Response> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        "${baseUrl}login/",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        String token = response.data["access"];
        await saveToken(token);
      }

      return response;
    } catch (e) {
      throw Exception("Login gagal: $e");
    }
  }

  Future<Response> getData(String endpoint) async {
    String? token = await getToken();
    return _dio.get(
      "$baseUrl$endpoint/",
      options: Options(
        headers: token != null ? {"Authorization": "Bearer $token"} : {},
      ),
    );
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    return _dio.post(
      "$baseUrl$endpoint/",
      data: data,
      options: Options(
        headers: token != null ? {"Authorization": "Bearer $token"} : {},
      ),
    );
  }
}
