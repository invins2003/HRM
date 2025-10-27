import 'dart:io';

import 'package:erp_admin/module/expense/controller/expense_controller.dart';
import 'package:erp_admin/module/expense/screens/expense_details.dart';
import 'package:erp_admin/module/expense/screens/log_expense_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with SingleTickerProviderStateMixin {
  late ExpenseController expenseController;
  double totalAvailable = 100000.0; // initial amount
  final List<Map<String, dynamic>> expenseUsed = [];
  final List<Map<String, dynamic>> expenseRequests = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    expenseController = Get.put(ExpenseController());
    expenseController.fetchExpenses();

    // ✅ ADDED: Fetch credit expenses as well
    expenseController.fetchCreditExpenses();

    expenseController.getLatestBalance();
    expenseController.fetchMyFundRequests();
    expenseController.fetchExpenseCategories();
  }

  /// Expense Request Dialog
  void showRequestDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Request Expense",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.currency_rupee,
                          color: Colors.green,
                        ),
                        labelText: "Requested Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: purposeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.assignment,
                          color: Colors.green,
                        ),
                        labelText: "Purpose / Reason",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: expenseController.isLoading.value
                        ? null
                        : () async {
                            /// Validate input
                            if (amountController.text.isEmpty ||
                                purposeController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final amount = double.tryParse(
                              amountController.text,
                            );
                            if (amount == null || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Enter a valid amount!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            /// API call to request expense
                            await expenseController.createFundRequest(
                              amount: amount,
                              reason: purposeController.text,
                            );

                            if (expenseController.fundRequest.value?.success ==
                                true) {
                              setState(() {
                                expenseRequests.add({
                                  "amount": amount,
                                  "purpose": purposeController.text,
                                  "status": "Pending",
                                });
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Expense request submitted successfully ✅",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Failed to submit expense request ❌",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    child: expenseController.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Submit"),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Total Available Amount
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  "Available Balance: ₹${expenseController.availableBalance.value.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Action Buttons
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.note_add, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LogExpenseScreen(),
                          ),
                        );

                        // Optional: Refresh after returning
                        if (result == true) {
                          // ✅ CHANGED: Refresh both lists
                          await Future.wait([
                            expenseController.fetchExpenses(),
                            expenseController.fetchCreditExpenses(),
                          ]);
                          await expenseController.getLatestBalance();
                        }
                      },
                      label: const Text(
                        "Log Expense",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.request_page, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: showRequestDialog,
                      label: const Text(
                        "Request Expense",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Tabs
            Container(
              color: Colors.green.shade100,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.green.shade800,
                indicator: BoxDecoration(
                  color: Colors.green,
                  // optionally round corners
                ),
                indicatorSize:
                    TabBarIndicatorSize.tab, // makes indicator full-width
                tabs: const [
                  Tab(text: "Used Records"),
                  Tab(text: "Requests"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// Tab Content with DataTable
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// Tab 1: Expense Used Records
                  Obx(() {
                    // ✅ CHANGED: Check both loading flags
                    if (expenseController.isFetchingNormal.value ||
                        expenseController.isFetchingCredit.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ✅ CHANGED: Combine both normal and credit lists
                    final normalRecords =
                        expenseController.expenseList.value?.data ?? [];
                    final creditRecords =
                        expenseController.expenseCreditList.value?.data ?? [];

                    final records = [...normalRecords, ...creditRecords];

                    // ✅ ADDED: Sort combined list by date (newest first)
                    records.sort((a, b) {
                      try {
                        if (a.paymentDate == null && b.paymentDate == null)
                          return 0;
                        if (a.paymentDate == null) return 1; // nulls at the end
                        if (b.paymentDate == null) return -1;
                        return DateTime.parse(
                          b.paymentDate!,
                        ).compareTo(DateTime.parse(a.paymentDate!));
                      } catch (e) {
                        // Fallback for invalid date format
                        return 0;
                      }
                    });

                    return RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.green,
                      onRefresh: () async {
                        // ✅ CHANGED: Refresh both lists
                        await Future.wait([
                          expenseController.fetchExpenses(),
                          expenseController.fetchCreditExpenses(),
                        ]);
                      },
                      child: records.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: Text(
                                    "No used records",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: records.length,
                              itemBuilder: (context, index) {
                                final record = records[index];

                                // ✅ CHANGED: Logic for avatar color
                                final isCash =
                                    (record.typeOfSupplOrService ?? "")
                                        .isEmpty;
                                final avatarColor =
                                    isCash ? Colors.green : Colors.blue;

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExpenseDetailsScreen(
                                          expense: record,
                                          categoryList:
                                              expenseController.categoryList,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        // ✅ CHANGED: Avatar color is now dynamic
                                        CircleAvatar(
                                          backgroundColor: avatarColor,
                                          child: const Icon(
                                            Icons.currency_rupee,
                                            // ✅ CHANGED: Icon color to white
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // ✅ CHANGED: Row now only contains Amount
                                              Row(
                                                children: [
                                                  Text(
                                                    "₹${record.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  // ✅ REMOVED: SizedBox and Chip
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                record.description ??
                                                    "No Description",
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                record.paymentDate != null &&
                                                        record.paymentDate!
                                                            .isNotEmpty
                                                    ? "• ${DateFormat('dd MMM yyyy').format(DateTime.parse(record.paymentDate!))}"
                                                    : "• Not Paid",
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          (record.paymentsStatus?.toLowerCase() ?? record.paymentStatus?.toLowerCase()) ==  "paid" ? Icons.check_circle : Icons.pending,
                                          color: (record.paymentsStatus?.toLowerCase() ?? record.paymentStatus?.toLowerCase()) == "paid"? Colors.green : Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  }),

                  /// Tab 2: Expense Requests
                  Obx(() {
                    // ✅ FIXED: Changed from 'isFetching' to 'isFetchingRequests'
                    if (expenseController.isFetchingRequests.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final requests =
                        expenseController.fundRequestList.value?.data ?? [];

                    return RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.green,
                      onRefresh: () async {
                        await expenseController.fetchMyFundRequests();
                      },
                      child: requests.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: Text(
                                    "No requests yet",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                final request = requests[index];

                                // 🟩 Status color mapping
                                Color statusColor = Colors.orange;
                                final status =
                                    request.status?.toLowerCase() ?? 'pending';

                                if (status == 'paid') {
                                  statusColor = Colors.green; // Paid = Blue
                                } else if (status == 'received') {
                                  statusColor = Colors.blue; // Received = Green
                                } else if (status == 'rejected') {
                                  statusColor = Colors.red;
                                }

                                return GestureDetector(
                                  onTap: () async {
                                    if (status == 'paid') {
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Confirm Receipt"),
                                          content: const Text(
                                            "Have you received the payment for this request?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("No"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                "Yes, Received",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        // 🟩 Call your controller method to update backend
                                        await expenseController.updateStatus(
                                          id: request.id!,
                                          status: "received",
                                        );

                                        // 🟩 Refresh the request list from backend
                                        await expenseController
                                            .fetchMyFundRequests();

                                        Get.snackbar(
                                          "Success",
                                          "Marked as received successfully ✅",
                                          backgroundColor: Colors.green
                                              .withOpacity(0.2),
                                          colorText: Colors.black,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.green.shade100,
                                          child: const Icon(
                                            Icons.request_page,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "₹${request.amount ?? "0"}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                request.reason ??
                                                    "No reason provided",
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                request.createdAt != null
                                                    ? "• ${request.createdAt!.split('T').first}"
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            request.status?.capitalizeFirst ??
                                                "Pending",
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}