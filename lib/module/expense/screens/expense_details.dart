import 'package:erp_admin/module/expense/model/expense_category.dart';
import 'package:erp_admin/module/expense/screens/widgets/imageviewer.dart';
import 'package:erp_admin/module/expense/screens/widgets/pdfviewer.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:erp_admin/module/expense/model/all_expense_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;
  final RxList<ExpenseCategory> categoryList;

  const ExpenseDetailsScreen({
    super.key,
    required this.expense,
    required this.categoryList,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName =
        categoryList
            .firstWhere(
              (cat) => cat.id == expense.categoryId,
              orElse: () => ExpenseCategory(
                id: 0,
                name: "Not Available",
                createdBy: 1,
                isDeleted: false,
                createdAt: "1",
                updatedAt: "1",
              ),
            )
            .name;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Expense Details",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              _buildDetailsCard(context, categoryName),
              const SizedBox(height: 24),
              if (expense.items != null && expense.items!.isNotEmpty)
                _buildItemsCard(context),
              const SizedBox(height: 24), // Added padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "₹${expense.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if(expense.paymentsStatus != null  || expense.paymentStatus != null)
          Positioned(top: -12, right: -12, child: _buildStatusBadge()),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = expense.paymentsStatus?.toLowerCase() ?? expense.paymentStatus?.toLowerCase();
    Color badgeColor;
    IconData badgeIcon;

    switch (status) {
      case "paid":
        badgeColor = Colors.green.shade700;
        badgeIcon = Icons.check_circle;
        break;
      case "pending":
        badgeColor = Colors.orange.shade700; // Made orange stronger
        badgeIcon = Icons.hourglass_top;
        break;
      case "rejected":
        badgeColor = Colors.red.shade700; // Made red stronger
        badgeIcon = Icons.cancel;
        break;
      default:
        badgeColor = Colors.grey.shade600;
        badgeIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(badgeIcon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            expense.paymentsStatus?.toUpperCase() ?? expense.paymentStatus!.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // --- REFACTORED THIS WIDGET ---
  Widget _buildDetailsCard(BuildContext context, String categoryName) {
    final formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final List<Widget> detailWidgets = [];

    // Helper to add row with divider if list is not empty
    void addDetailRow(Widget row) {
      if (detailWidgets.isNotEmpty) {
        detailWidgets.add(_divider());
      }
      detailWidgets.add(row);
    }

    // --- Expense ID ---
    if (expense.id != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.confirmation_num_outlined, // Changed to outlined
        title: "Expense ID",
        value: expense.id.toString(),
      ));
    }

 if (expense.vendorname != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.man, // Changed to outlined
        title: "Vendor Name",
        value: expense.vendorname.toString(),
      ));
    }

     if (expense.typeOfSupplOrService != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.money, // Changed to outlined
        title: "Purchase Type",
        value: expense.typeOfSupplOrService.toString(),
      ));
    }


    // --- Category ---
    if (categoryName != "Not Available") {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.category_outlined, // Changed to outlined
        title: "Category",
        value: categoryName,
      ));
    }

    // --- Branch ---
    if (expense.branch?.name != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.store_outlined, // Changed to outlined
        title: "Branch",
        value: expense.branch!.name!,
      ));
    }

    // --- Paid By ---
    if (expense.creator?.name != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.person_outline,
        title: "Paid By",
        value: expense.creator!.name!,
      ));
    }

    // --- Payment Date ---
    if (expense.paymentDate != null && expense.paymentDate!.isNotEmpty) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.calendar_today_outlined,
        title: "Payment Date",
        value: formatter.format(DateTime.parse(expense.paymentDate!)),
      ));
    }

    // --- Description ---
    if (expense.description != null && expense.description!.isNotEmpty) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.description_outlined,
        title: "Description",
        value: expense.description!,
      ));
    }

    // --- Subtotal ---
    if (expense.subtotal != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.receipt_long_outlined,
        title: "Subtotal",
        value: "₹${expense.subtotal!.toStringAsFixed(2)}",
      ));
    }

    // --- Tax Total ---
    if (expense.taxTotal != null) {
      addDetailRow(_detailRow(
        context: context,
        icon: Icons.calculate_outlined,
        title: "Tax Total",
        value: "₹${expense.taxTotal!.toStringAsFixed(2)}",
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: detailWidgets,
      ),
    );
  }

  // --- REFACTORED THIS WIDGET ---
  Widget _buildItemsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...expense.items!.map((item) {
            final taxString = item.isTaxable == true
                ? "Tax: ${item.taxType ?? "-"} (${item.taxRate?.toStringAsFixed(2) ?? "0"}%)"
                : "No Tax";
            final subtotalString =
                "Subtotal: ₹${item.subtotal?.toStringAsFixed(2) ?? "0.00"}";

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.label_outline, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.itemName ?? "N/A",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          "₹${item.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          subtotalString,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          taxString,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    if (item.document != null && item.document!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: double.infinity, // Full width button
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _openDocument(context, item.document),
                            icon: const Icon(Icons.remove_red_eye, size: 18),
                            label: const Text("View Document"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        color: Colors.grey.shade200,
        height: 1,
        indent: 16,
        endIndent: 16,
      );

  // --- CORRECTED THIS WIDGET ---
  // --- CORRECTED THIS WIDGET AGAIN ---
  Widget _detailRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: isLink ? onTap : null,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isLink ? Colors.green.shade700 : Colors.black87,
                    decoration: isLink
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: Colors.green.shade700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDocument(BuildContext context, String? doc) {
    if (doc == null || doc.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Document not found.")));
      return;
    }

    final url = doc.startsWith("http") ? doc : "${Constants.BASEURL}/$doc";
    final ext = url.split('.').last.toLowerCase();

    if (ext == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PDFViewerScreen(url: url)),
      );
    } else if (['jpg', 'jpeg', 'png'].contains(ext)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ImageViewerScreen(url: url)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unsupported document type")),
      );
    }
  }
}