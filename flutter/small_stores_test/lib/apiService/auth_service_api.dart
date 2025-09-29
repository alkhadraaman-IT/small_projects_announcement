import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // طباعة الاستجابة الكاملة
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }else if (response.statusCode == 401) {
      // خطأ في المصادقة (بريد أو كلمة سر خاطئة)
      throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    } else if (response.statusCode == 403) {
      // حساب محظور
      throw Exception('الحساب محظور. يرجى التواصل مع الدعم');
    } else if (response.statusCode == 404) {
      // البريد غير موجود
      throw Exception('البريد الإلكتروني غير مسجل');
    }    else {
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'type': type,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'status': 200, 'user': data['user'], 'access_token': data['access_token']};
      } else if (response.statusCode == 422) {
        // أخطاء الفالديشن
        String message = 'حدث خطأ';
        if (data['errors'] != null) {
          if (data['errors']['email'] != null) {
            message = 'البريد الإلكتروني مستخدم مسبقاً';
          } else if (data['errors']['phone'] != null) {
            message = 'رقم الهاتف مستخدم مسبقاً';
          }
        }
        return {'status': 422, 'message': message};
      } else {
        return {'status': response.statusCode, 'message': data['message'] ?? 'خطأ غير معروف'};
      }
    } catch (e) {
      return {'status': 500, 'message': 'خطأ في الاتصال: $e'};
    }
  }

  static Future<Map<String, dynamic>> getMe(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user data');
    }
  }
}