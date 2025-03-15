import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vilcart/repository/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<bool> login(String mobileNo, String password) async {
    try {
      final response = await _apiService.post(
        "/auth/signin",
        data: {
          "mobileNo": mobileNo,
          "password": password,
          "userGroup": "warehouse",
          "client": "web",
        },
      );

      if (response.statusCode == 200) {
        String token = response.data["token"];
        if (token.isEmpty) {
          throw Exception("Token is empty");
        }

        // Store the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        // Decode JWT and store warehouseId if valid
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken.containsKey("warehouses") &&
            decodedToken["warehouses"].isNotEmpty) {
          int warehouseId = decodedToken["warehouses"][0]["id"];
          await prefs.setInt("warehouse_id", warehouseId);
        } else {
          throw Exception("Invalid token: Warehouse ID not found");
        }

        return true;
      } else {
        throw Exception(
          "Login failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      log("Auth Error: $e");
      throw Exception("Inavlid User Name or password!");
    }
  }
}
