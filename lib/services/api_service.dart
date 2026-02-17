import 'package:schooly/constant/export_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://192.168.1.23:8000/api';
  static const String baseUrl = 'http://16.171.134.243/api';

  static final client = http.Client();

  static const headers = {
    'Accept': 'application/json',
    "Content-Type": "application/json",
  };

  static Future<Map<String, dynamic>> _post(String endpoint, Map body) async {
    final res = await client.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      return data;
    } else {
      throw data["message"] ?? "Server error";
    }
  }

  static Future<LoginModel> login(Map body) async =>
      LoginModel.fromJson(await _post("login", body));

  static Future<RegisterModel> register(Map body) async =>
      RegisterModel.fromJson(await _post("register", body));

  static Future<SendOtpModel> sendOtp(Map body) async =>
      SendOtpModel.fromJson(await _post("send-otp", body));

  static Future<LoginModel> verifyOtp(Map body) async =>
      LoginModel.fromJson(await _post("otp-verify", body));

  static Future<LoginModel> socialLogin(Map body) async =>
      LoginModel.fromJson(await _post("social-login", body));
}
