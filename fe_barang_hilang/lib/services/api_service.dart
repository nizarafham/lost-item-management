import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() {
    return 'ApiException: $statusCode, $message';
  }
}

class ApiService {
  final String baseUrl;
  final http.Client client = http.Client();

  ApiService({required String baseUrl})
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000';

  Future<Map<String, String>> getHeaders() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? token = await user?.getIdToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders();
    try {
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.body, response.statusCode);
      }
    } catch (e) {
      print('GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders();
    try {
      final response = await client.post(url, headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.body, response.statusCode);
      }
    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders();
    try {
      final response = await client.put(url, headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.body, response.statusCode);
      }
    } catch (e) {
      print('PUT Error: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders();
    try {
      final response = await client.delete(url, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.body, response.statusCode);
      }
    } catch (e) {
      print('DELETE Error: $e');
      rethrow;
    }
  }

  Future<dynamic> postWithImage(String endpoint, dynamic data, String imagePath) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await getHeaders();
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imagePath.isNotEmpty) {
        try {
          request.files.add(await http.MultipartFile.fromPath('image', imagePath));
        }catch(e){
          throw ApiException('image not found', 400);
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.body, response.statusCode);
      }
    } catch (e) {
      print('POST with Image Error: $e');
      rethrow;
    }
  }
}