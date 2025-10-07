import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // for formatting date+time
import '../../DashBoard/Model/EmployeesLIstModel.dart';
import '../Controller/EmployeeListController/EmployeeListController.dart';
import 'EmployeeProfileScreen.dart';

class ListWidget extends StatelessWidget {
  final List<Data> employeelist;

  const ListWidget({super.key, required this.employeelist});

  @override
  Widget build(BuildContext context) {
    // Access controller for Delete & Default actions
    final EmployeeListController controller = Get.put(
      EmployeeListController(employeeListRepo: Get.find()),
    );

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: employeelist.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final employee = employeelist[index];

              return ListTile(
                /// Show first letter as avatar
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: Text(
                    employee.name != null && employee.name!.isNotEmpty
                        ? employee.name![0].toUpperCase()
                        : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                title: Text(employee.name ?? "No Name"),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID : ${employee.employeeId ?? "N/A"}"),
                    Text(
                      employee.email ?? "N/A",
                      style: TextStyle(
                        color: (employee.email != null &&
                                employee.email!.isNotEmpty)
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                /// Popup Menu (4 Options)
                trailing: PopupMenuButton<String>(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == "view") {
                      if (employee.employeeId != null) {
                        Get.to(
                          () => EmployeeProfileScreen(
                            employeeId:
                                int.tryParse(employee.employeeId.toString()) ??
                                    0,
                          ),
                        );
                      }
                    } else if (value == "delete") {
                      controller.deleteEmployee(employee);
                    } else if (value == "default") {
                      controller.setDefaultEmployee(employee);
                    } else if (value == "early leave") {
                      _showEarlyLeaveDialog(context, controller, employee);
                    } else if (value == "Overtime") {
                      _showOverTimeDialog(context, controller, employee);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "view",
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.blue),
                          SizedBox(width: 8),
                          Text("Employee Profile"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Overtime",
                      child: Row(
                        children: [
                          Icon(Icons.work_history, color: Colors.green),
                          SizedBox(width: 8),
                          Text("Overtime"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "early leave",
                      child: Row(
                        children: [
                          Icon(Icons.directions_walk_rounded, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Early Leave"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete Employee"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Show Dialog for Early Leave (Date + Time)
void _showEarlyLeaveDialog(
    BuildContext context, EmployeeListController controller, Data employee) {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final reasonController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      dateController.text =
          DateFormat("yyyy-MM-dd").format(picked); // ✅ date only
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      timeController.text =
          DateFormat("HH:mm:ss").format(dt); // ✅ time only
    }
  }

  Get.defaultDialog(
    title: "Early Leave - ${employee.name}",
    content: Column(
      children: [
        TextField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Date (yyyy-MM-dd)",
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _pickDate,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: timeController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Early Leave Time (HH:mm:ss)",
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: _pickTime,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: "Reason",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ),
    textCancel: "Cancel",
    textConfirm: "Submit",
    confirmTextColor: Colors.white,
    onConfirm: () {
      if (employee.employeeId != null) {
        controller.updateEarlyLeavingController(
          empId: employee.employeeId.toString(),
          date: dateController.text.trim(),       // yyyy-MM-dd
          earlyLeaving: timeController.text.trim(), // HH:mm:ss ✅
          reason: reasonController.text.trim(),
        );
      } else {
        Get.snackbar("Error", "Employee ID not available");
      }
      Get.back(); // close dialog
    },
  );
}

void _showOverTimeDialog(
    BuildContext context, EmployeeListController controller, Data employee) {
  final dateController2 = TextEditingController();
  final timeController2 = TextEditingController();
  final reasonController2 = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      dateController2.text =
          DateFormat("yyyy-MM-dd").format(picked); // ✅ date only
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      timeController2.text =
          DateFormat("HH:mm:ss").format(dt); // ✅ time only
    }
  }

  Get.defaultDialog(
    title: "Overtime - ${employee.name}",
    content: Column(
      children: [
        TextField(
          controller: dateController2,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Date (yyyy-MM-dd)",
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _pickDate,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: timeController2,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Early Leave Time (HH:mm:ss)",
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: _pickTime,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reasonController2,
          decoration: const InputDecoration(
            labelText: "Reason",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ),
    textCancel: "Cancel",
    textConfirm: "Submit",
    confirmTextColor: Colors.white,
    onConfirm: () {
      if (employee.employeeId != null) {
        controller.updateOverTimeController(
          empId: employee.employeeId.toString(),
          date: dateController2.text.trim(),       // yyyy-MM-dd
          overtime: timeController2.text.trim(), // HH:mm:ss ✅
          reason: reasonController2.text.trim(),
        );
      } else {
        Get.snackbar("Error", "Employee ID not available");
      }
      Get.back(); // close dialog
    },
  );
}

