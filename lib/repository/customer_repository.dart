import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/model/business_model.dart';
import 'package:vilcart/repository/api_service.dart';

class CustomerRepository {
  final ApiService _apiService = ApiService();

  Future<List<Business>> getAllCustomers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? warehouseId = prefs.getInt("warehouse_id");

      if (warehouseId == null) throw Exception("Warehouse ID not found");

      final response = await _apiService.get(
        "/customer/warehouse/$warehouseId",
      );

      if (response.statusCode == 200) {
        log("CustomerRepository API Response: ${response.data}");

        // ✅ Ensure response is a Map and contains 'result' key
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('result')) {
          List<dynamic> result = response.data['result'];

          // ✅ Ensure each item in `result` is a valid Map before mapping
          List<Business> businessList =
              result
                  .where((element) => element is Map<String, dynamic>)
                  .map(
                    (json) => Business.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          return businessList;
        } else {
          log(
            "❌ Error: API response is missing 'result' or has incorrect format.",
          );
          return [];
        }
      } else {
        log("❌ Failed to fetch customers: ${response.statusCode}");
        throw Exception("Failed to fetch customers");
      }
    } catch (e) {
      log("❌ Error fetching customers: $e");
      throw Exception("Error fetching customers: $e");
    }
  }
}
