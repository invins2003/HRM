import 'dart:io';
import 'package:erp_admin/module/expense/model/all_expense_model.dart';
import 'package:erp_admin/module/expense/model/expense_category.dart';
import 'package:erp_admin/module/expense/model/fund_request_model.dart';
import 'package:erp_admin/module/expense/model/request_fund_list_model.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Model/expense_model.dart';
import '../Repo/expense_repo.dart';

class ExpenseController extends GetxController {
  final ExpenseRepo expenseRepo = ExpenseRepo();

  RxBool isLoading = false.obs;
    RxBool isFetching = false.obs;
  Rx<ExpenseResponse?> expenseList = Rx<ExpenseResponse?>(null);
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
        Fluttertoast.showToast(msg: "No categories found ❌");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching categories: $e");
    } finally {
      isFetchingCategories.value = false;
    }
  }

  Future<void> createExpense({
    required int categoryId,
    required String description,
    required double amount,
    required double taxRate,
    required bool isTaxable,
    File? document,
  }) async {
    isLoading.value = true;

    final result = await expenseRepo.createExpense(
      description: description,
      amount: amount,
      taxRate: taxRate,
      isTaxable: isTaxable,
      document: document,
      categoryId: categoryId
    );

    isLoading.value = false;

    if (result != null && result.success == true) {
      expenseResponse.value = result;
      Fluttertoast.showToast(msg: "Expense created successfully ✅");
    } else {
      Fluttertoast.showToast(msg: result?.message ?? "Failed to create expense ❌");
    }
  }


  Future<void> fetchExpenses() async {
    try {
      isFetching.value = true;
      final result = await expenseRepo.fetchExpenses();

      if (result.success) {
        expenseList.value = result;
      }
    } catch (e) {
      expenseList.value = ExpenseResponse(success: false, data: []);
      Fluttertoast.showToast(msg: "Error fetching expenses: $e");
    } finally {
      isFetching.value = false;
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
        Fluttertoast.showToast(msg: "Fund request submitted ✅");
      } else {
        Fluttertoast.showToast(msg: "Failed to submit fund request ❌");
      }
    } catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: "Error: $e");
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
    Fluttertoast.showToast(msg: "Error fetching requests: $e");
  } finally {
    isFetchingRequests.value = false;
  }
}


}
