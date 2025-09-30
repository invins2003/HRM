import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with SingleTickerProviderStateMixin {
  double totalAvailable = 10000.0; // initial amount
  final List<Map<String, dynamic>> expenseUsed = [];
  final List<Map<String, dynamic>> expenseRequests = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  /// Expense Used Reason Dialog
  void showUsedReasonDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Log Expense Used",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.currency_rupee, color: Colors.green),
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.note_alt, color: Colors.green),
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  reasonController.text.isNotEmpty) {
                double spentAmount = double.parse(amountController.text);
                if (spentAmount > totalAvailable) {
                  // cannot spend more than available
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Insufficient balance!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  totalAvailable -= spentAmount; // subtract from available
                  expenseUsed.add({
                    "amount": spentAmount,
                    "reason": reasonController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Expense Request Dialog
  void showRequestDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Request Expense",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.currency_rupee, color: Colors.green),
                labelText: "Requested Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.assignment, color: Colors.green),
                labelText: "Purpose",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  purposeController.text.isNotEmpty) {
                setState(() {
                  expenseRequests.add({
                    "amount": double.parse(amountController.text),
                    "purpose": purposeController.text,
                    "status": "Pending"
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
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
            Container(
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
                "Available Balance: ₹${totalAvailable.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  SingleChildScrollView(
                    // padding: const EdgeInsets.all(12),
                    scrollDirection: Axis.vertical,
                    child: expenseUsed.isEmpty
                        ? Expanded(
                          child: const Center(
                              child: Text("No used records",
                                  style: TextStyle(color: Colors.grey))),
                        )
                        : DataTable(

                            // columnSpacing: 20,
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green.shade200),
                            columns: const [
                              DataColumn(
                                headingRowAlignment: MainAxisAlignment.center,
                                  label: Center(
                                    child: Text('Amount',
                                    textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  )),
                              DataColumn(
                                headingRowAlignment: MainAxisAlignment.center,
                                  label: Center(
                                    child: Text('Reason',
                                    textAlign: TextAlign.center,
                                        style: TextStyle(
                                          
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ],
                            rows: expenseUsed
                                .map((record) => DataRow(cells: [
                                      DataCell(Center(
                                        child: Text("₹${record['amount']}",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Center(child: Text(record['reason']))),
                                    ]))
                                .toList(),
                          ),
                  ),

                  /// Tab 2: Expense Requests
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: expenseRequests.isEmpty
                        ? const Center(
                            child: Text("No requests yet",
                                style: TextStyle(color: Colors.grey)))
                        : DataTable(
                          border: TableBorder.all(),
                            columnSpacing: 20,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green.shade200),
                            columns: const [
                              DataColumn(
                                headingRowAlignment: MainAxisAlignment.center,
                                  label: Text('Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                headingRowAlignment: MainAxisAlignment.center,
                                  label: Text('Purpose',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                headingRowAlignment: MainAxisAlignment.center,
                                  label: Text('Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: expenseRequests
                                .map((request) => DataRow(cells: [
                                      DataCell(Center(
                                        child: Text("₹${request['amount']}",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                      )),
                                      DataCell(Center(child: Text(request['purpose']))),
                                      DataCell(Center(child: Text(request['status']))),
                                    ]))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
