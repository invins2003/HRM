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

  const ExpenseDetailsScreen({super.key, required this.expense, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    final categoryName = categoryList
        .firstWhere(
          (cat) => cat.id == expense.categoryId,
          orElse: () => ExpenseCategory(
              id: 0, name: "Not Available", createdBy: 1, isDeleted: false, createdAt: "1", updatedAt: "1"),
        )
        .name;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Expense Details", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildDetailsCard(context, categoryName),
            const SizedBox(height: 24),
          ],
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
              const Text("Total Amount", style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                "₹${expense.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Positioned(top: -12, right: -12, child: _buildStatusBadge()),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    IconData badgeIcon;
    String status = expense.paymentsStatus.toLowerCase();

    switch (status) {
      case "paid":
        badgeColor = Colors.green.shade700;
        badgeIcon = Icons.check_circle;
        break;
      case "pending":
        badgeColor = Colors.orange;
        badgeIcon = Icons.hourglass_top;
        break;
      case "rejected":
        badgeColor = Colors.red;
        badgeIcon = Icons.cancel;
        break;
      default:
        badgeColor = Colors.grey;
        badgeIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Icon(badgeIcon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            expense.paymentsStatus.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, String categoryName) {
    final formatter = DateFormat('dd MMM yyyy, hh:mm a');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _detailRow(context: context,   icon: Icons.category, title: "Category", value: categoryName),
          _divider(),
          _detailRow(context: context,  icon: Icons.description_outlined, title: "Description", value: expense.description),
          _divider(),
          _detailRow(context: context,   icon: Icons.person_outline, title: "Paid By", value: expense.creator.name),
          _divider(),
          _detailRow(
            context: context,
            icon: Icons.calendar_today_outlined,
            title: "Payment Date",
            value: expense.paymentDate.isNotEmpty
                ? formatter.format(DateTime.parse(expense.paymentDate))
                : "N/A",
          ),
          _divider(),
          _detailRow(context: context,  icon: Icons.receipt_long_outlined, title: "Subtotal", value: "₹${expense.subtotal.toStringAsFixed(2)}"),
          _divider(),
          _detailRow(context: context,   icon: Icons.calculate_outlined, title: "Tax Total", value: "₹${expense.taxTotal.toStringAsFixed(2)}"),
          _divider(),
          _detailRow(context: context,   icon: Icons.store_outlined, title: "Branch", value: expense.branch.name),
          _divider(),
          _detailRow(
            context: context,
            icon: Icons.attach_file_outlined,
            title: "Document",
            value: expense.document != null ? "Attached" : "No document",
            isLink: expense.document != null,
            onTap: () {
              if (expense.document != null && expense.document!.isNotEmpty) {
                final url = expense.document!.startsWith("http")
                    ? expense.document!
                    : "${Constants.BASEURL}/${expense.document}";
                final ext = url.split('.').last.toLowerCase();

                if (ext == 'pdf') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PDFViewerScreen(url: url)));
                } else if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ImageViewerScreen(url: url)));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Unsupported document type")));
                }
              }
            },
            builder: (context, value, isLink) {
              if (!isLink) return Text(value, style: const TextStyle(color: Colors.black87));

              return Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (expense.document != null && expense.document!.isNotEmpty) {
                      final url = expense.document!.startsWith("http")
                          ? expense.document!
                          : "${Constants.BASEURL}/${expense.document}";
                      final ext = url.split('.').last.toLowerCase();

                      if (ext == 'pdf') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PDFViewerScreen(url: url)));
                      } else if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ImageViewerScreen(url: url)));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Unsupported document type")));
                      }
                    }
                  },
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text("View Document"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade200, height: 1, indent: 16, endIndent: 16);
  }

  Widget _detailRow({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
  bool isLink = false,
  VoidCallback? onTap,
  Widget Function(BuildContext context, String value, bool isLink)? builder,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(width: 16),
        // Remove Expanded here
        builder != null
            ? builder(context, value, isLink)
            : GestureDetector(
                onTap: isLink ? onTap : null,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isLink ? Colors.green : Colors.black87,
                      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: Colors.green,
                    ),
                  ),
                ),
              ),
      ],
    ),
  );
}
}
