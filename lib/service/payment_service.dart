import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = "http://151.243.222.93:31020/api";

  static Future<String> checkStatus(String invoiceId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/status/$invoiceId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"] ?? "pending";
    }

    return "pending";
  }
}
