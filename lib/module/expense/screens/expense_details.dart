import 'package:flutter/material.dart';
import 'package:erp_admin/module/expense/model/all_expense_model.dart'; // Your model
import 'package:intl/intl.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
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
            _buildDetailsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Builds the top card with the total amount and status badge.
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Changed from teal to green
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Changed from teal to green
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
                "₹${expense.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Positioned(
            top: -12,
            right: -12,
            child: _buildStatusBadge(),
          ),
        ],
      ),
    );
  }

  /// Builds the status badge with dynamic color and icon.
  Widget _buildStatusBadge() {
    Color badgeColor;
    IconData badgeIcon;
    String status = expense.paymentsStatus.toLowerCase();

    switch (status) {
      case "paid":
        badgeColor = Colors.green.shade700; // Using a darker green for contrast
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
            expense.paymentsStatus.toUpperCase(),
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

  /// Builds the card containing all the expense details.
  Widget _buildDetailsCard() {
    final formatter = DateFormat('dd MMM yyyy, hh:mm a');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.description_outlined,
            title: "Description",
            value: expense.description,
          ),
          _divider(),
          _detailRow(
            icon: Icons.person_outline,
            title: "Paid By",
            value: expense.creator.name,
          ),
          _divider(),
          _detailRow(
            icon: Icons.calendar_today_outlined,
            title: "Payment Date",
            value: expense.paymentDate.isNotEmpty
                ? formatter.format(DateTime.parse(expense.paymentDate))
                : "N/A",
          ),
          _divider(),
          _detailRow(
            icon: Icons.receipt_long_outlined,
            title: "Subtotal",
            value: "₹${expense.subtotal.toStringAsFixed(2)}",
          ),
          _divider(),
          _detailRow(
            icon: Icons.calculate_outlined,
            title: "Tax Total",
            value: "₹${expense.taxTotal.toStringAsFixed(2)}",
          ),
          _divider(),
          _detailRow(
            icon: Icons.store_outlined,
            title: "Branch",
            value: expense.branch.name,
          ),
          _divider(),
          _detailRow(
            icon: Icons.attach_file_outlined,
            title: "Document",
            value: expense.document ?? "No document attached",
            isLink: expense.document != null,
            onTap: () {
              // TODO: Implement document opening/download logic
              print("Opening document: ${expense.document}");
            },
          ),
        ],
      ),
    );
  }

  /// A helper to create a consistent divider.
  Widget _divider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  /// Builds a single row for a detail item.
  Widget _detailRow({
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
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: isLink ? onTap : null,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  // Changed from teal to green
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