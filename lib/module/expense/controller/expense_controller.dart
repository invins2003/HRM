import 'dart:io';
import 'package:dio/src/multipart_file.dart' hide MultipartFile;
import 'package:erp_admin/module/expense/model/all_expense_model.dart';
import 'package:erp_admin/module/expense/model/expense_category.dart';
import 'package:erp_admin/module/expense/model/fund_request_model.dart';
import 'package:erp_admin/module/expense/model/request_fund_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/expense_model.dart';
import '../Repo/expense_repo.dart';

class ExpenseController extends GetxController {
  final ExpenseRepo expenseRepo = ExpenseRepo();

  RxBool isLoading = false.obs;

  // ✅ CHANGED: Replaced 'isFetching' with two separate flags
  RxBool isFetchingNormal = false.obs;
  RxBool isFetchingCredit = false.obs;

  Rx<ExpenseResponse?> expenseList = Rx<ExpenseResponse?>(null);
  Rx<ExpenseResponse?> expenseCreditList = Rx<ExpenseResponse?>(null);
  Rx<ExpenseModel?> expenseResponse = Rx<ExpenseModel?>(null);

  RxList<ExpenseCategory> categoryList = <ExpenseCategory>[].obs;
  RxBool isFetchingCategories = false.obs;

  Future<void> fetchExpenseCategories() async {
    try {
      isFetchingCategories.value = true;
      final result = await expenseRepo.getExpenseCategories();

      if (result.isNotEmpty) {
        categoryList.assignAll(result);
      } else {
        // Fluttertoast.showToast(msg: "No categories found ❌");
        Get.snackbar(
          "Not found",
          "No categories found ❌",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.red,
        );
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error fetching categories: $e");
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFetchingCategories.value = false;
    }
  }

  Future<void> createExpense({
    required int categoryId,
    required String description,
    required List<Map<String, dynamic>> items,
    required Map<String, MultipartFile> files,
    required String purchaseType,
    String? vendorName,
    String? creditPurchaseType,
  }) async {
    isLoading.value = true;
    dynamic result;

    if (purchaseType == "Cash Purchase") {
      result = await expenseRepo.createExpense(
        description: description,
        items: items,
        files: files,
        categoryId: categoryId,
        purchaseType: purchaseType,
      );
    } else {
      result = await expenseRepo.createExpense(
        description: description,
        items: items,
        files: files,
        categoryId: categoryId,
        purchaseType: purchaseType,
        vendorName: vendorName,
        creditPurchaseType: creditPurchaseType,
      );
    }

    isLoading.value = false;

    if (result != null && result.success == true) {
      expenseResponse.value = result;
      // Fluttertoast.showToast(msg: "Expense created successfully ✅");
      Get.snackbar(
        "successfully",
        "Expense created successfully ✅",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // Fluttertoast.showToast(
      //     msg: result?.message ?? "Failed to create expense ❌");
      Get.snackbar(
        "Failed",
        result?.message ?? "Failed to create expense ❌",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchExpenses() async {
    try {
      // ✅ CHANGED: Use 'isFetchingNormal'
      isFetchingNormal.value = true;
      final result = await expenseRepo.fetchExpenses();

      if (result.success!) {
        expenseList.value = result;
      }
    } catch (e) {
      expenseList.value = ExpenseResponse(success: false, data: []);
      // Fluttertoast.showToast(msg: "Error fetching expenses: $e");
      Get.snackbar(
        "Error",
        "Error fetching expenses: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // ✅ CHANGED: Use 'isFetchingNormal'
      isFetchingNormal.value = false;
    }
  }

  Future<void> fetchCreditExpenses() async {
    try {
      // ✅ CHANGED: Use 'isFetchingCredit'
      isFetchingCredit.value = true;
      final result = await expenseRepo.fetchCreditExpenses();

      if (result.success!) {
        expenseCreditList.value = result;
      }
    } catch (e) {
      expenseCreditList.value = ExpenseResponse(success: false, data: []);
      // Fluttertoast.showToast(msg: "Error fetching expenses: $e");
      Get.snackbar(
        "Error",
        "Error fetching expenses: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // ✅ CHANGED: Use 'isFetchingCredit'
      isFetchingCredit.value = false;
    }
  }

  RxDouble availableBalance = 0.0.obs;

  Future<void> getLatestBalance() async {
    try {
      isLoading.value = true;
      double? balance = await expenseRepo.fetchLatestBalance();
      if (balance != null) {
        availableBalance.value = balance;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Rx<FundRequestModel?> fundRequest = Rx<FundRequestModel?>(null);

  Future<void> createFundRequest({
    required double amount,
    required String reason,
  }) async {
    try {
      isLoading.value = true;

      final result = await expenseRepo.createFundRequest(
        amount: amount,
        reason: reason,
      );

      isLoading.value = false;

      if (result != null && result.success == true) {
        fundRequest.value = result;
        // Fluttertoast.showToast(msg: "Fund request submitted ✅");
        Get.snackbar(
          "Submitted",
          "Fund request submitted ✅",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Fluttertoast.showToast(msg: "Failed to submit fund request ❌");
        Get.snackbar(
          "Failed",
          "Failed to submit fund request ❌",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      // Fluttertoast.showToast(msg: "Error: $e");
      Get.snackbar(
        "Error",
        "Error $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Rx<FundRequestListModel?> fundRequestList = Rx<FundRequestListModel?>(null);
  RxBool isFetchingRequests = false.obs;

  Future<void> fetchMyFundRequests() async {
    try {
      isFetchingRequests.value = true;
      final result = await expenseRepo.fetchMyFundRequests();
      fundRequestList.value = result;
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error fetching requests: $e");
      Get.snackbar(
        "Error",
        "Error fetching requests:$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFetchingRequests.value = false;
    }
  }

  // ✅ Update Fund Request Status (e.g. "received")
  Future<void> updateStatus({required int id, required String status}) async {
    try {
      isLoading.value = true;

      final response = await expenseRepo.updateStatus(id: id, status: status);

      if (response.statusCode == 200 &&
          (response.body['success'] == true ||
              response.body['message']?.toString().contains("updated") ==
                  true)) {
        // Fluttertoast.showToast(msg: "Status updated to $status ✅");
        Get.snackbar(
          "Status",
          "Status updated to $status ✅",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the fund request list after updating
        await fetchMyFundRequests();
      } else {
        // Fluttertoast.showToast(
        //   msg: "Failed to update status ❌ (${response.statusCode})",
        // );
        Get.snackbar(
          "Failed",
          "Failed to update status ❌ (${response.statusCode})",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error updating status: $e");
      Get.snackbar(
        "Error",
        "Error updating status: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
