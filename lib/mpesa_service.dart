import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  static const String stkEndpoint =
      'https://fjorzgowplrsfohozlhd.supabase.co/functions/v1/mpesa-stk';

  static const String supabaseAnonKey =
      'Sb_publishable_cNCrYuy6BDDTYC2j4gYSYw_P6cnWVVK';

  static Future sendStkPush({
    required String phone,
    required int amount,
    required String orderId,
  }) async {
    final uri = Uri.parse(stkEndpoint);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $supabaseAnonKey',
        'apikey': supabaseAnonKey,
      },
      body: jsonEncode({
        'phone': phone.trim(),
        'amount': amount,
        'orderId': orderId.trim(),
      }),
    );

    final dynamic decoded =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded is Map) {
      return decoded;
    }

    final errorMessage = decoded is Map && decoded['error'] != null
        ? decoded['error'].toString()
        : 'Imeshindwa kutuma STK Push (Status: ${response.statusCode})';
    throw Exception(errorMessage);
  }
}
