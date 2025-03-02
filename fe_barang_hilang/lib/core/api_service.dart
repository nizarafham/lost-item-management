import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api/lostfound/";
  final Dio _dio = Dio();

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Response> getData(String endpoint) async {
    String? token = await getToken();
    return _dio.get(
      "$baseUrl$endpoint/",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    return _dio.post(
      "$baseUrl$endpoint/",
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
