import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vilcart/core/repository/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<bool> login(
    String mobileNo,
    String password, {
    bool rememberMe = false,
  }) async {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        // Decode token to retrieve warehouse ID.
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken.containsKey("warehouses") &&
            decodedToken["warehouses"].isNotEmpty) {
          int warehouseId = decodedToken["warehouses"][0]["id"];
          await prefs.setInt("warehouse_id", warehouseId);
        } else {
          throw Exception("Invalid token: Warehouse ID not found");
        }

        if (rememberMe) {
          await prefs.setString("saved_mobileNo", mobileNo);
          await prefs.setString("saved_password", password);
          await prefs.setBool("remember_me", true);
        } else {
          await prefs.remove("saved_mobileNo");
          await prefs.remove("saved_password");
          await prefs.setBool("remember_me", false);
        }
        return true;
      } else {
        throw Exception(
          "Login failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      log("Auth Error: $e");
      throw Exception("Invalid username or password!");
    }
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      await prefs.clear();
      return false;
    }
    int? warehouseId = prefs.getInt("warehouse_id");
    if (warehouseId == null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey("warehouses") &&
          decodedToken["warehouses"].isNotEmpty) {
        warehouseId = decodedToken["warehouses"][0]["id"];
        await prefs.setInt("warehouse_id", warehouseId!);
      } else {
        await prefs.clear();
        return false;
      }
    }
    return true;
  }

  Future<int?> getWarehouseId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? warehouseId = prefs.getInt("warehouse_id");
    if (warehouseId == null) {
      String? token = prefs.getString("auth_token");
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken.containsKey("warehouses") &&
            decodedToken["warehouses"].isNotEmpty) {
          warehouseId = decodedToken["warehouses"][0]["id"];
          await prefs.setInt("warehouse_id", warehouseId!);
        }
      }
    }
    return warehouseId;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("remember_me") ?? false;
    if (rememberMe) {
      return {
        "mobileNo": prefs.getString("saved_mobileNo"),
        "password": prefs.getString("saved_password"),
      };
    }
    return {"mobileNo": null, "password": null};
  }
}
