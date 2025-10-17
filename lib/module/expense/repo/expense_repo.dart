import 'dart:io';
import 'package:erp_admin/module/expense/model/all_expense_model.dart';
import 'package:erp_admin/module/expense/model/expense_category.dart';
import 'package:erp_admin/module/expense/model/fund_request_model.dart';
import 'package:erp_admin/module/expense/model/request_fund_list_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';
import '../Model/expense_model.dart';
import 'package:mime/mime.dart';

class ExpenseRepo {
  final ApiClient apiClient= ApiClient(appBaseUrl: Constants.BASEURL);



  Future<List<ExpenseCategory>> getExpenseCategories() async {
    try {
      final response = await apiClient.getData("/api/expense-category");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.body;

        if (jsonData['success'] == true) {
          final List<dynamic> list = jsonData['data'];
          return list.map((e) => ExpenseCategory.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching expense categories: $e");
      return [];
    }
  }


Future<ExpenseModel?> createExpense({
  required int categoryId,
  required String description,
  required double amount,
  required double taxRate,
  required bool isTaxable,
  File? document,
}) async {
  try {
    final formData = FormData({
      "category_id": categoryId,
      "description": description,
      "amount": amount,
      "tax_rate": taxRate,
      "is_taxable": isTaxable ? 1 : 0,
      if (document != null)
        "document": MultipartFile(
          document.path,
          filename: document.path.split('/').last,
          contentType: lookupMimeType(document.path).toString(), // ✅ String MIME type
        ),
    });

    final response = await apiClient.postDataWithFile(
      Constants.CREATEEXPENSE,
      formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ExpenseModel.fromJson(response.body);
    } else {
      return ExpenseModel(
        success: false,
        message: "Failed with status: ${response.statusCode}",
      );
    }
  } catch (e) {
    print("Error in createExpense: $e");
    return ExpenseModel(success: false, message: e.toString());
  }
}



   Future<ExpenseResponse> fetchExpenses() async {
    try {
      final response = await apiClient.getData(Constants.GETEXPENSE);

      if (response.statusCode == 200) {
        return ExpenseResponse.fromJson(response.body);
      } else {
        return ExpenseResponse(success: false, data: []);
      }
    } catch (e) {
      print("Error in fetchExpenses: $e");
      return ExpenseResponse(success: false, data: []);
    }
   }


   Future<double?> fetchLatestBalance() async {
  try {
    final response = await apiClient.getData(Constants.GETBALANCE);

    if (response.statusCode == 200) {
      // If ApiClient returns decoded JSON, don't decode again
      final Map<String, dynamic> jsonData = response.body;

      if (jsonData['success'] == true && jsonData['data'] != null) {
        final data = jsonData['data'];

        if (data is List && data.isNotEmpty) {
          // If latest balance is first
          final latestBalance = double.tryParse(data[0]['balance_after'].toString());
          return latestBalance;
        } else if (data is Map && data.containsKey('balance_after')) {
          // If API returns a single object
          return double.tryParse(data['balance_after'].toString());
        }
      }
    }
    return null;
  } catch (e) {
    print("Error fetching branch wallet: $e");
    return null;
  }
}


Future<FundRequestModel?> createFundRequest({
    required double amount,
    required String reason,
  }) async {
    try {
      final body = {
        "amount": amount,
        "reason": reason,
      };

      final response = await apiClient.postData(Constants.FUNDREQUEST, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If ApiClient returns decoded JSON
        final Map<String, dynamic> jsonData = response.body;
        return FundRequestModel.fromJson(jsonData);
      } else {
        print("Failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error in createFundRequest: $e");
      return null;
    }
  }


  Future<FundRequestListModel> fetchMyFundRequests() async {
  try {
    final response = await apiClient.getData(Constants.MYFUNDREQUEST);

    if (response.statusCode == 200) {
      return FundRequestListModel.fromJson(response.body);
    } else {
      return FundRequestListModel(success: false, data: []);
    }
  } catch (e) {
    print("Error fetching fund requests: $e");
    return FundRequestListModel(success: false, data: []);
  }
}
}
