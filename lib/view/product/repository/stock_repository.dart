import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/core/repository/api_service.dart';
import 'package:vilcart/model/product_model.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> fetchStockStatement(
    String date,
    int customerId,
    int page,
    int limit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? warehouseId = prefs.getInt("warehouse_id");

    if (warehouseId == null) {
      throw Exception("Warehouse ID not found!");
    }

    await prefs.setString("selected_date", date);
    await prefs.setInt("customer_id", customerId);

    try {
      final response = await _apiService.post(
        "/stock/statement/date/$date/warehouse/$warehouseId/customer/$customerId",
        data: {"pageNumber": page, "pageLimit": limit},
      );

      if (response.statusCode == 200) {
        log("Product Response Data: ${response.data}");

        Map<String, dynamic> responseData = response.data;
        if (responseData.containsKey("result") &&
            responseData["result"] is List) {
          List<dynamic> result = responseData["result"];

          if (result.isNotEmpty) {
            return result.map((json) => Product.fromJson(json)).toList();
          } else {
            log("No products found or end of data reached!");
            return [];
          }
        } else {
          throw Exception("Invalid API response: 'result' not found!");
        }
      } else {
        log("Failed to fetch stock statement: ${response.statusCode}");
        throw Exception("Failed to fetch stock statement!");
      }
    } catch (e, st) {
      log("Stock Error: $e");
      throw Exception("Stock Error: $e  $st");
    }
  }

  bool hasMoreData(int currentPage, int limit, List<Product> currentData) {
    return currentData.length == limit;
  }
}
