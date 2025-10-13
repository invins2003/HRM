import 'dart:io';

import 'package:erp_admin/module/expense/controller/expense_controller.dart';
import 'package:erp_admin/module/expense/screens/expense_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    expenseController.getLatestBalance();
    expenseController.fetchMyFundRequests();
    expenseController.fetchExpenseCategories();
  }

  /// Expense Used Reason Dialog
void showUsedReasonDialog() {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController taxRateController = TextEditingController();

  bool isTaxable = false;
  File? selectedFile;
  int? selectedCategoryId;

  // Fetch categories if not already fetched
  // if (expenseController.categoryList.isEmpty) {
  //   expenseController.fetchExpenseCategories();
  // }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Log Expense",
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
                /// Description
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.description, color: Colors.green),
                    labelText: "Description / Reason",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),

                /// Category Dropdown
                Obx(() {
                  if (expenseController.isFetchingCategories.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.green));
                  }

                  final categories = expenseController.categoryList;
                  if (categories.isEmpty) {
                    return const Text("No categories found", style: TextStyle(color: Colors.red));
                  }

                  return DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories.map(
                      (cat) => DropdownMenuItem<int>(
                        value: cat.id,
                        child: Text(cat.name),
                      ),
                    ).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedCategoryId = value!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category, color: Colors.green),
                      labelText: "Select Category",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  );
                }),
                const SizedBox(height: 12),

                /// Amount
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.currency_rupee, color: Colors.green),
                    labelText: "Amount",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),

                /// Is Taxable
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Is this expense taxable?",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Switch(
                      activeColor: Colors.green,
                      value: isTaxable,
                      onChanged: (val) {
                        setStateDialog(() {
                          isTaxable = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Tax Rate (only if taxable)
                if (isTaxable)
                  Column(
                    children: [
                      TextField(
                        controller: taxRateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.percent, color: Colors.green),
                          labelText: "Tax Rate (%)",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                /// File Picker
                OutlinedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(type: FileType.any);
                    if (result != null) {
                      setStateDialog(() {
                        selectedFile = File(result.files.single.path!);
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_file, color: Colors.green),
                  label: Text(
                    selectedFile == null
                        ? "Attach Document ${isTaxable ? '(required)' : '(optional)'}"
                        : "Attached: ${selectedFile!.path.split('/').last}",
                    style: const TextStyle(color: Colors.green),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.green)),
            ),
            Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: expenseController.isLoading.value
                    ? null
                    : () async {
                        /// Validation
                        if (descriptionController.text.isEmpty ||
                            amountController.text.isEmpty ||
                            selectedCategoryId == null ||
                            (isTaxable && taxRateController.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (isTaxable && selectedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Document upload is required for taxable expenses!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        double? amount = double.tryParse(amountController.text);
                        double? taxRate = double.tryParse(taxRateController.text);

                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter a valid amount!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (amount > totalAvailable) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Insufficient balance!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        /// API Call
                        await expenseController.createExpense(
                          description: descriptionController.text,
                          amount: amount,
                          taxRate: taxRate ?? 0.0,
                          isTaxable: isTaxable,
                          document: selectedFile,
                          categoryId: selectedCategoryId!, // pass the ID
                        );

                        if (expenseController.expenseResponse.value?.success == true) {
                          setState(() {
                            totalAvailable -= amount;
                            expenseUsed.add({
                              "amount": amount,
                              "reason": descriptionController.text,
                              "category": expenseController.categoryList
                                  .firstWhere((c) => c.id == selectedCategoryId)
                                  .name,
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                child: expenseController.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Save"),
              );
            }),
          ],
        ),
      );
    },
  );
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      prefixIcon: const Icon(Icons.currency_rupee, color: Colors.green),
                      labelText: "Requested Amount",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: purposeController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.assignment, color: Colors.green),
                      labelText: "Purpose / Reason",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: expenseController.isLoading.value
                      ? null
                      : () async {
                          /// Validate input
                          if (amountController.text.isEmpty || purposeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields!"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final amount = double.tryParse(amountController.text);
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

                          if (expenseController.fundRequest.value?.success == true) {
                            setState(() {
                              expenseRequests.add({
                                "amount": amount,
                                "purpose": purposeController.text,
                                "status": "Pending",
                              });
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Expense request submitted successfully ✅"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to submit expense request ❌"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: expenseController.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
            Obx(() => Container(
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
                )),
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
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: showUsedReasonDialog,
                      label: const Text("Log Expense",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon:
                          const Icon(Icons.request_page, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: showRequestDialog,
                      label: const Text("Request Expense",
                          style: TextStyle(color: Colors.white)),
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
    indicatorSize: TabBarIndicatorSize.tab, // makes indicator full-width
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
        if (expenseController.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = expenseController.expenseList.value?.data ?? [];

        return RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.green,
          onRefresh: () async {
            await expenseController.fetchExpenses();
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
                    return InkWell(
                       onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpenseDetailsScreen(expense: record,categoryList:expenseController.categoryList),
      ),
    );
  },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(Icons.currency_rupee,
                                  color: Colors.green),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${record.totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(record.description),
                                  const SizedBox(height: 2),
                                  Text(
                                    "• ${record.paymentDate}",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              record.paymentsStatus.toLowerCase() == "paid"
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: record.paymentsStatus.toLowerCase() == "paid"
                                  ? Colors.green
                                  : Colors.orange,
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
  if (expenseController.isFetching.value) {
    return const Center(child: CircularProgressIndicator());
  }

  final requests = expenseController.fundRequestList.value?.data ?? [];

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
                child: Text("No requests yet", style: TextStyle(color: Colors.grey)),
              ),
            ],
          )
        : ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              Color statusColor = Colors.orange;
              if (request.status?.toLowerCase() == 'approved') {
                statusColor = Colors.green;
              } else if (request.status?.toLowerCase() == 'rejected') {
                statusColor = Colors.red;
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.request_page, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${request.amount ?? "0"}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(request.reason ?? "No reason provided"),
                          const SizedBox(height: 2),
                          Text(
                            request.createdAt != null
                                ? "• ${request.createdAt!.split('T').first}"
                                : "",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request.status?.capitalizeFirst ?? "Pending",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
  );
}),

    ],
  ),
)

         ],
        ),
      ),
    );
  }
}
