

import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeListController/EmployeeListController.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/employee_leaves_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Screens/create_leave_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmployeeLeavesScreen extends StatefulWidget {
  final String empId;
  const EmployeeLeavesScreen({super.key, required this.empId});

  @override
  State<EmployeeLeavesScreen> createState() => _EmployeeLeavesScreenState();
}

class _EmployeeLeavesScreenState extends State<EmployeeLeavesScreen> {
  final EmployeeListController controller = Get.put(
    EmployeeListController(employeeListRepo: Get.find()),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchEmployeeLeaves(widget.empId);
    controller.fetchLeaveTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Employee Leaves"),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isLeaveLoading.value ||
            controller.isLeaveTypeLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (controller.employeeLeaves.isEmpty) {
          return const Center(
            child: Text(
              "No leaves found.",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.employeeLeaves.length,
          itemBuilder: (context, index) {
            final LeaveData leave = controller.employeeLeaves[index];

            String startDate = leave.startDate != null
                ? DateFormat(
                    "dd MMM yyyy",
                  ).format(DateTime.parse(leave.startDate!))
                : "-";
            String endDate = leave.endDate != null
                ? DateFormat(
                    "dd MMM yyyy",
                  ).format(DateTime.parse(leave.endDate!))
                : "-";

            String leaveTypeName = controller.getLeaveTypeName(
              leave.leaveTypeId,
            );

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.green.shade100, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Leave type + days
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          leaveTypeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                        if (leave.totalLeaveDays != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${leave.totalLeaveDays} days",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Dates
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$startDate  →  $endDate",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Reason
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            leave.leaveReason ?? "No reason provided",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Remark (if exists)
                    if (leave.remark != null && leave.remark!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.comment,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                leave.remark!,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Divider(height: 1, color: Colors.greenAccent),
                    const SizedBox(height: 8),

                    // Status Row
                    Row(
                      children: [
                        Icon(
                          leave.status == "Approved"
                              ? Icons.check_circle
                              : leave.status == "Rejected"
                              ? Icons.cancel
                              : Icons.hourglass_top,
                          color: leave.status == "Approved"
                              ? Colors.green
                              : leave.status == "Rejected"
                              ? Colors.red
                              : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          leave.status ?? "-",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: leave.status == "Approved"
                                ? Colors.green
                                : leave.status == "Rejected"
                                ? Colors.red
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    // 🔽 Buttons (Edit / Delete / Approve / Reject)
                    if (leave.status == "Pending") ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () =>
                                _showEditLeaveDialog(context, leave),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                _confirmDeleteLeave(context, leave),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              leave.status = "Approved";
                              controller.employeeLeaves.refresh();
                              await controller.updateLeaveController(
                                leave,
                                leaveId: leave.id.toString(),
                                empId: leave.employeeId.toString(),
                                status: "Approved",
                              );
                            },
                            child: const Text("Approve"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              leave.status = "Rejected";
                              controller.employeeLeaves.refresh();
                              await controller.updateLeaveController(
                                leave,
                                leaveId: leave.id.toString(),
                                empId: leave.employeeId.toString(),
                                status: "Rejected",
                              );
                            },
                            child: const Text("Reject"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Get.to(
            () => CreateLeaveScreen(empId: widget.empId),
          );
          if (result == true) {
            controller.fetchEmployeeLeaves(widget.empId);
          }
        },
      ),
    );
  }

  /// ✅ Edit Leave Dialog (with future date disabled)
  void _showEditLeaveDialog(BuildContext context, LeaveData leave) {
  bool isEditable = leave.status == "Pending";

  // Parse existing dates
  DateTime? initiatedDate = leave.appliedOn != null
      ? DateTime.tryParse(leave.appliedOn!)
      : DateTime.now();
  DateTime? startDate = leave.startDate != null
      ? DateTime.tryParse(leave.startDate!)
      : DateTime.now();
  DateTime? endDate = leave.endDate != null
      ? DateTime.tryParse(leave.endDate!)
      : DateTime.now();

  // Controllers
  final initiatedDateController = TextEditingController(
    text: initiatedDate != null
        ? DateFormat("dd MMM yyyy").format(initiatedDate)
        : "",
  );
  final startDateController = TextEditingController(
    text: startDate != null ? DateFormat("dd MMM yyyy").format(startDate) : "",
  );
  final endDateController = TextEditingController(
    text: endDate != null ? DateFormat("dd MMM yyyy").format(endDate) : "",
  );
  final reasonController = TextEditingController(text: leave.leaveReason ?? "");
  final remarkController = TextEditingController(text: leave.remark ?? "");

  // Reactive leave type selection (fix for dropdown)
  RxInt selectedLeaveTypeId = (leave.leaveTypeId ?? 0).obs;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Leave",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),

              // Leave Type Dropdown
              Obx(() {
                return DropdownButtonFormField<int>(
                  value: selectedLeaveTypeId.value,
                  decoration: const InputDecoration(
                    labelText: "Leave Type",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.leaveTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.id,
                          child: Text(type.title ?? ""),
                        ),
                      )
                      .toList(),
                  onChanged: isEditable
                      ? (val) {
                          if (val != null) selectedLeaveTypeId.value = val;
                        }
                      : null,
                );
              }),
              const SizedBox(height: 12),

              // Applied On
              _buildDateField(
                context,
                controller: initiatedDateController,
                label: "Applied On",
                isEditable: isEditable,
                currentDate: initiatedDate,
                onPicked: (picked) => initiatedDate = picked,
              ),
              const SizedBox(height: 12),

              // Start Date
              _buildDateField(
                context,
                controller: startDateController,
                label: "Start Date",
                isEditable: isEditable,
                currentDate: startDate,
                onPicked: (picked) => startDate = picked,
              ),
              const SizedBox(height: 12),

              // End Date
              _buildDateField(
                context,
                controller: endDateController,
                label: "End Date",
                isEditable: isEditable,
                currentDate: endDate,
                onPicked: (picked) => endDate = picked,
              ),
              const SizedBox(height: 12),

              // Reason
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
                readOnly: !isEditable,
              ),
              const SizedBox(height: 12),

              // Remark
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(
                  labelText: "Remark",
                  border: OutlineInputBorder(),
                ),
                readOnly: !isEditable,
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  if (isEditable)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        leave.leaveTypeId = selectedLeaveTypeId.value;
                        leave.appliedOn = DateFormat("yyyy-MM-dd")
                            .format(initiatedDate ?? DateTime.now());
                        leave.startDate = DateFormat("yyyy-MM-dd")
                            .format(startDate ?? DateTime.now());
                        leave.endDate = DateFormat("yyyy-MM-dd")
                            .format(endDate ?? DateTime.now());
                        leave.leaveReason = reasonController.text.trim();
                        leave.remark = remarkController.text.trim();

                        await controller.updateLeaveController(
                          leave,
                          leaveId: leave.id.toString(),
                          empId: leave.employeeId.toString(),
                          leaveReason: leave.leaveReason,
                          remark: leave.remark,
                          leaveTypeId: leave.leaveTypeId,
                          startDate: leave.startDate,
                          endDate: leave.endDate,
                          appliedOn: leave.appliedOn,
                        );

                        controller.employeeLeaves.refresh();
                        Navigator.of(Get.context!, rootNavigator: true).pop();
                      },
                      child: const Text("Save"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// 🔹 Reusable Date Picker (future-proof and safe)
Widget _buildDateField(
  BuildContext context, {
  required TextEditingController controller,
  required String label,
  required bool isEditable,
  DateTime? currentDate,
  required Function(DateTime) onPicked,
}) {
  return GestureDetector(
    onTap: isEditable
        ? () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: currentDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onPicked(picked);
              controller.text = DateFormat("dd MMM yyyy").format(picked);
            }
          }
        : null,
    child: AbsorbPointer(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
        ),
        readOnly: true,
      ),
    ),
  );
}


  /// ✅ Confirmation dialog for delete
  void _confirmDeleteLeave(BuildContext context, LeaveData leave) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Leave"),
        content: const Text("Are you sure you want to delete this leave?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              await controller.deleteLeave(leave.id.toString(), widget.empId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
