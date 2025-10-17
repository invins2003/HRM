// import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_type_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeListController/EmployeeListController.dart';
// import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_create_model.dart';
//
// class CreateLeaveScreen extends StatefulWidget {
//   final String empId;
//   const CreateLeaveScreen({super.key, required this.empId});
//
//   @override
//   State<CreateLeaveScreen> createState() => _CreateLeaveScreenState();
// }
//
// class _CreateLeaveScreenState extends State<CreateLeaveScreen> {
//   late EmployeeListController controller;
//
//   LeaveTypeData? selectedLeaveType;
//   DateTime? startDate;
//   DateTime? endDate;
//   DateTime appliedDate = DateTime.now(); // New applied date
//
//   final TextEditingController reasonController = TextEditingController();
//   final TextEditingController remarkController = TextEditingController();
//   final TextEditingController startDateController = TextEditingController();
//   final TextEditingController endDateController = TextEditingController();
//   final TextEditingController appliedDateController = TextEditingController();
//
//   int get totalDays {
//     if (startDate != null && endDate != null) {
//       return endDate!.difference(startDate!).inDays + 1;
//     }
//     return 0;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.find<EmployeeListController>();
//     appliedDateController.text = DateFormat('dd MMM yyyy').format(appliedDate);
//
//     // Fetch leave types after first frame to avoid build conflicts
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.leaveTypes.isEmpty) {
//         controller.fetchLeaveTypes();
//       }
//     });
//   }
//
//   Future<void> _pickStartDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (date != null) {
//       setState(() {
//         startDate = date;
//         startDateController.text = DateFormat('dd MMM yyyy').format(date);
//
//         if (endDate != null && endDate!.isBefore(startDate!)) {
//           endDate = startDate;
//           endDateController.text = startDateController.text;
//         }
//       });
//     }
//   }
//
//   Future<void> _pickEndDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: endDate ?? (startDate ?? DateTime.now()),
//       firstDate: startDate ?? DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (date != null) {
//       setState(() {
//         endDate = date;
//         endDateController.text = DateFormat('dd MMM yyyy').format(date);
//       });
//     }
//   }
//
//   Future<void> _pickAppliedDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: appliedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (date != null) {
//       setState(() {
//         appliedDate = date;
//         appliedDateController.text = DateFormat('dd MMM yyyy').format(date);
//       });
//     }
//   }
//
//   void _submitLeave() async {
//     if (selectedLeaveType == null ||
//         startDate == null ||
//         endDate == null ||
//         reasonController.text.trim().isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please fill all fields",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     final leave = LeaveModel(
//       employeeId: int.parse(widget.empId),
//       leaveTypeId: selectedLeaveType!.id,
//       appliedOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
//       startDate: DateFormat('yyyy-MM-dd').format(startDate!),
//       endDate: DateFormat('yyyy-MM-dd').format(endDate!),
//       totalLeaveDays: totalDays.toString(),
//       leaveReason: reasonController.text.trim(),
//       remark: remarkController.text.trim(),
//     );
//
//     final success = await controller.createLeave(leave);
//
//     if (success) {
//       Get.snackbar(
//         "Success",
//         "Leave created successfully",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       await Future.delayed(const Duration(milliseconds: 600));
//       if (Get.isOverlaysOpen)
//         Navigator.pop(context, true); // ✅ closes snackbars first
//       else
//         Navigator.pop(context, true); // ✅ return to list page
//     } else {
//       Get.snackbar(
//         "Error",
//         "Failed to create leave",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Create Leave"),
//         backgroundColor: Colors.green,
//       ),
//       body: Obx(() {
//         if (controller.isLeaveTypeLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.green),
//           );
//         }
//
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: ListView(
//             children: [
//               // Leave Type Dropdown
//               DropdownButtonFormField<LeaveTypeData>(
//                 value: selectedLeaveType,
//                 decoration: const InputDecoration(
//                   labelText: "Leave Type",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: controller.leaveTypes.map((leaveType) {
//                   return DropdownMenuItem<LeaveTypeData>(
//                     value: leaveType,
//                     child: Text(leaveType.title ?? "Unknown"),
//                   );
//                 }).toList(),
//                 onChanged: (val) => setState(() => selectedLeaveType = val),
//               ),
//               const SizedBox(height: 16),
//
//               // Applied Date Picker
//               TextField(
//                 readOnly: true,
//                 controller: appliedDateController,
//                 decoration: InputDecoration(
//                   labelText: "Applied Date",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today, color: Colors.green),
//                     onPressed: _pickAppliedDate,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Start Date Picker
//               TextField(
//                 readOnly: true,
//                 controller: startDateController,
//                 decoration: InputDecoration(
//                   labelText: "Start Date",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today, color: Colors.green),
//                     onPressed: _pickStartDate,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // End Date Picker
//               TextField(
//                 readOnly: true,
//                 controller: endDateController,
//                 decoration: InputDecoration(
//                   labelText: "End Date",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today, color: Colors.green),
//                     onPressed: _pickEndDate,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Total Days
//               Card(
//                 color: Colors.green.withOpacity(0.1),
//                 elevation: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     "Total Days: $totalDays",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Reason
//               TextField(
//                 controller: reasonController,
//                 maxLines: 2,
//                 decoration: const InputDecoration(
//                   labelText: "Reason",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Remark (optional)
//               TextField(
//                 controller: remarkController,
//                 maxLines: 2,
//                 decoration: const InputDecoration(
//                   labelText: "Remark",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 onPressed: _submitLeave,
//                 child: const Text(
//                   "Submit Leave",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeListController/EmployeeListController.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_create_model.dart';

class CreateLeaveScreen extends StatefulWidget {
  final String empId;
  const CreateLeaveScreen({super.key, required this.empId});

  @override
  State<CreateLeaveScreen> createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen> {
  late EmployeeListController controller;

  LeaveTypeData? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  DateTime appliedDate = DateTime.now();

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController appliedDateController = TextEditingController();

  int get totalDays {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays + 1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<EmployeeListController>();
    appliedDateController.text = DateFormat('dd MMM yyyy').format(appliedDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.leaveTypes.isEmpty) {
        controller.fetchLeaveTypes();
      }
    });
  }

  /// ✅ START DATE PICKER — Future Dates Disabled
  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // ✅ no future date
      selectableDayPredicate: (day) {
        // ✅ allow only today or past days
        return !day.isAfter(DateTime.now());
      },
    );
    if (date != null) {
      setState(() {
        startDate = date;
        startDateController.text = DateFormat('dd MMM yyyy').format(date);
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = startDate;
          endDateController.text = startDateController.text;
        }
      });
    }
  }

  /// ✅ END DATE PICKER — Future Dates Disabled
  Future<void> _pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime.now(), // ✅ no future date
      selectableDayPredicate: (day) {
        return !day.isAfter(DateTime.now());
      },
    );
    if (date != null) {
      setState(() {
        endDate = date;
        endDateController.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  /// ✅ APPLIED DATE PICKER — Future Dates Disabled
  Future<void> _pickAppliedDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: appliedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // ✅ cannot pick future date
      selectableDayPredicate: (day) {
        return !day.isAfter(DateTime.now());
      },
    );
    if (date != null) {
      setState(() {
        appliedDate = date;
        appliedDateController.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  void _submitLeave() async {
    if (selectedLeaveType == null ||
        startDate == null ||
        endDate == null ||
        reasonController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final leave = LeaveModel(
      employeeId: int.parse(widget.empId),
      leaveTypeId: selectedLeaveType!.id,
      appliedOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      startDate: DateFormat('yyyy-MM-dd').format(startDate!),
      endDate: DateFormat('yyyy-MM-dd').format(endDate!),
      totalLeaveDays: totalDays.toString(),
      leaveReason: reasonController.text.trim(),
      remark: remarkController.text.trim(),
    );

    final success = await controller.createLeave(leave);

    if (success) {
      Get.snackbar(
        "Success",
        "Leave created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await Future.delayed(const Duration(milliseconds: 600));
      if (Get.isOverlaysOpen)
        Navigator.pop(context, true);
      else
        Navigator.pop(context, true);
    } else {
      Get.snackbar(
        "Error",
        "Failed to create leave",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Leave"),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isLeaveTypeLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              DropdownButtonFormField<LeaveTypeData>(
                value: selectedLeaveType,
                decoration: const InputDecoration(
                  labelText: "Leave Type",
                  border: OutlineInputBorder(),
                ),
                items: controller.leaveTypes.map((leaveType) {
                  return DropdownMenuItem<LeaveTypeData>(
                    value: leaveType,
                    child: Text(leaveType.title ?? "Unknown"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedLeaveType = val),
              ),
              const SizedBox(height: 16),

              TextField(
                readOnly: true,
                controller: appliedDateController,
                decoration: InputDecoration(
                  labelText: "Applied Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.green),
                    onPressed: _pickAppliedDate,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                readOnly: true,
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: "Start Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.green),
                    onPressed: _pickStartDate,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                readOnly: true,
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: "End Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.green),
                    onPressed: _pickEndDate,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                color: Colors.green.withOpacity(0.1),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Total Days: $totalDays",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: reasonController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: remarkController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Remark",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _submitLeave,
                child: const Text(
                  "Submit Leave",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
