import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/productmodel.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Product> products = body.map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('فشل بجلب البيانات');
    }
  }
}
