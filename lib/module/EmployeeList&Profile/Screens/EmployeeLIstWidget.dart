import 'package:erp_admin/module/EmployeeList&Profile/Screens/employeeLeavesscreen.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Screens/employeeattendencescreen.dart';
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
    final EmployeeListController controller = Get.put(
      EmployeeListController(employeeListRepo: Get.find()),
    );
    final activeEmployees = employeelist
        .where((e) => e.isActive == true)
        .toList();

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: Colors.green,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await controller.listtController();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: activeEmployees.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final employee = activeEmployees[index];

                return ListTile(
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
                          color:
                              (employee.email != null &&
                                  employee.email!.isNotEmpty)
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    onSelected: (value) {
                      if (value == "view") {
                        if (employee.employeeId != null) {
                          Get.to(
                            () => EmployeeProfileScreen(
                              employeeId:
                                  int.tryParse(
                                    employee.employeeId.toString(),
                                  ) ??
                                  0,
                            ),
                          );
                        }
                      }
                      // else if (value == "delete") {
                      //   Get.defaultDialog(
                      //     title: "Delete Employee",
                      //     titleStyle: const TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //     middleText:
                      //         "Are you sure you want to delete ${employee.name}?",
                      //     backgroundColor: Colors.white,
                      //     titlePadding: const EdgeInsets.all(12),
                      //     contentPadding: const EdgeInsets.all(12),
                      //     radius: 12,
                      //     textCancel: "Cancel",
                      //     textConfirm: "Delete",
                      //     confirmTextColor: Colors.white,
                      //     buttonColor: Colors.green,
                      //     onConfirm: () {
                      //       Get.back();
                      //     },
                      //   );
                      // }
                      else if (value == "leave") {
                        if (employee.employeeId != null) {
                          Get.to(
                            () => EmployeeLeavesScreen(
                              empId: employee.employeeId.toString(),
                            ),
                          );
                        } else {
                          Get.snackbar("Error", "Employee ID not available");
                        }
                      } else if (value == "view_attendance") {
                        if (employee.employeeId != null) {
                          Get.to(
                            () => EmployeeAttendanceScreen(
                              empId: employee.employeeId.toString(),
                            ),
                          );
                        } else {
                          Get.snackbar("Error", "Employee ID not available");
                        }
                      } else if (value == "terminate") {
                        _showTerminationDialog(context, controller, employee);
                      } else if (value == "resign") {
                        _showResignationDialog(context, controller, employee);
                      } else if (value == "early leave") {
                        _showEarlyLeaveDialog(context, controller, employee);
                      } else if (value == "Overtime") {
                        _showOverTimeDialog(context, controller, employee);
                      } else if (value == "manage_attendance") {
                        _showManageAttendanceDialog(
                          context,
                          controller,
                          employee,
                        );
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
                            Icon(
                              Icons.directions_walk_rounded,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text("Early Leave"),
                          ],
                        ),
                      ),

                      PopupMenuItem(
                        value: "terminate",
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel_schedule_send,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 8),
                            Text("Terminate"),
                          ],
                        ),
                      ),

                      // const PopupMenuItem(
                      //   value: "delete",
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.delete, color: Colors.red),
                      //       SizedBox(width: 8),
                      //       Text("Delete Employee"),
                      //     ],
                      //   ),
                      // ),
                      PopupMenuItem(
                        value: "resign",
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.orange),
                            SizedBox(width: 8),
                            Text("Resignation"),
                          ],
                        ),
                      ),

                      const PopupMenuItem(
                        value: "manage_attendance",
                        child: Row(
                          children: [
                            Icon(Icons.edit_calendar, color: Colors.orange),
                            SizedBox(width: 8),
                            Text("Manage Attendance"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "leave",
                        child: Row(
                          children: [
                            Icon(Icons.rule_outlined, color: Colors.grey),
                            SizedBox(width: 8),
                            Text("Manage Leave"),
                          ],
                        ),
                      ),

                      const PopupMenuItem(
                        value: "view_attendance",
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 8),
                            Text("View Attendance"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// void _showResignationDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) async {
//   final resignationDateController = TextEditingController();
//   final descriptionController = TextEditingController();
//
//   Future<void> _pickResignationDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       // lastDate: DateTime(2100),
//       lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green, // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: Colors.black, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green, // OK & Cancel button color
//               ),
//             ),
//           ),
//           child: child!, // original date picker with our theme
//         );
//       },
//     );
//     if (picked != null) {
//       resignationDateController.text = DateFormat("yyyy-MM-dd").format(picked);
//     }
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: _buildThemedDialogContent(
//         title: "Resignation - ${employee.name}",
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 12),
//             TextField(
//               controller: resignationDateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Resignation Date",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: _pickResignationDate,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     if (employee.employeeId != null &&
//                         resignationDateController.text.isNotEmpty) {
//                       controller.createResignationController(
//                         employeeId: int.parse(employee.employeeId!),
//                         resignationDate: resignationDateController.text.trim(),
//                         description: descriptionController.text.trim(),
//                       );
//                       Get.back();
//                     } else {
//                       Get.snackbar("Error", "Please fill all fields");
//                     }
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
void _showResignationDialog(
  BuildContext context,
  EmployeeListController controller,
  Data employee,
) async {
  final resignationDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // ✅ Added form key

  Future<void> _pickResignationDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      resignationDateController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: _buildThemedDialogContent(
        title: "Resignation - ${employee.name}",
        child: Form(
          key: _formKey, // ✅ Added form for validation
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: resignationDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Resignation Date",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickResignationDate,
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a resignation date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a reason/description";
                  }
                  if (value.trim().length < 3) {
                    return "Description must be at least 3 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // ✅ Validate first
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (employee.employeeId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid Employee ID ❌"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.fixed,
                          ),
                        );
                        return;
                      }

                      // ✅ Submit resignation
                      await controller.createResignationController(
                        employeeId: int.parse(employee.employeeId!),
                        resignationDate: resignationDateController.text.trim(),
                        description: descriptionController.text.trim(),
                      );

                      // // ✅ Show success snackbar at bottom
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Resignation submitted successfully ✅"),
                      //     backgroundColor: Colors.green,
                      //     behavior: SnackBarBehavior.fixed, // bottom position
                      //     duration: Duration(seconds: 2),
                      //   ),
                      // );

                      Get.back(); // close dialog
                    },
                    child: const Text("Submit"),
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

/// TERMINATION DIALOG (Corrected & Reactive)
// void _showTerminationDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) async {
//   final terminationDateController = TextEditingController();
//   final descriptionController = TextEditingController();
//   RxInt selectedType = 0.obs; // make reactive
//   RxBool? isBlacklisted = false.obs; // default false
//
//   // Ensure types are fetched
//   if (controller.terminationTypes.isEmpty) {
//     await controller.fetchTerminationTypes();
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: _buildThemedDialogContent(
//         title: "Terminate - ${employee.name}",
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 12),
//             TextField(
//               controller: terminationDateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Termination Date",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2100),
//                       // lastDate: DateTime.now(),
//                       initialDate: DateTime.now(),
//                       // date color
//                       builder: (BuildContext context, Widget? child) {
//                         return Theme(
//                           data: ThemeData.light().copyWith(
//                             colorScheme: const ColorScheme.light(
//                               primary: Colors.green, // header background color
//                               onPrimary: Colors.white, // header text color
//                               onSurface: Colors.black, // body text color
//                             ),
//                             textButtonTheme: TextButtonThemeData(
//                               style: TextButton.styleFrom(
//                                 foregroundColor:
//                                     Colors.green, // OK & Cancel button color
//                               ),
//                             ),
//                           ),
//                           child: child!, // original date picker with our theme
//                         );
//                       },
//                     );
//                     if (picked != null) {
//                       terminationDateController.text = DateFormat(
//                         "yyyy-MM-dd",
//                       ).format(picked);
//                     }
//                   },
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             /// Reactive Dropdown for Termination Type
//             Obx(() {
//               if (controller.terminationTypes.isEmpty) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return DropdownButtonFormField<int>(
//                 value: selectedType.value == 0 ? null : selectedType.value,
//                 decoration: const InputDecoration(
//                   labelText: "Termination Type",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: controller.terminationTypes.map((type) {
//                   return DropdownMenuItem<int>(
//                     value: type.id,
//                     child: Text(type.name ?? ""),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   if (val != null) selectedType.value = val;
//                 },
//               );
//             }),
//             const SizedBox(height: 12),
//
//             /// Dropdown for Blacklist Yes/No
//             Obx(() {
//               return DropdownButtonFormField<bool>(
//                 value: isBlacklisted.value,
//                 decoration: const InputDecoration(
//                   labelText: "Is Blacklisted?",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem<bool>(value: true, child: Text("Yes")),
//                   DropdownMenuItem<bool>(value: false, child: Text("No")),
//                 ],
//                 onChanged: (val) {
//                   if (val != null) isBlacklisted.value = val;
//                 },
//               );
//             }),
//             const SizedBox(height: 12),
//
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     if (employee.employeeId != null &&
//                         terminationDateController.text.isNotEmpty &&
//                         selectedType.value != 0) {
//                       controller.createTerminationController(
//                         employeeId: int.parse(employee.employeeId!),
//                         terminationDate: terminationDateController.text.trim(),
//                         terminationType: selectedType.value,
//                         description: descriptionController.text.trim(),
//                         isblacklisted: isBlacklisted.value, // pass value
//                       );
//                       Get.back();
//                     } else {
//                       Get.snackbar(
//                         "Error",
//                         "Please fill all fields and select a termination type",
//                       );
//                     }
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
void _showTerminationDialog(
  BuildContext context,
  EmployeeListController controller,
  Data employee,
) async {
  final terminationDateController = TextEditingController();
  final descriptionController = TextEditingController();
  RxInt selectedType = 0.obs; // Reactive termination type
  RxBool isBlacklisted = false.obs; // Default value

  // Fetch termination types if not already loaded
  if (controller.terminationTypes.isEmpty) {
    await controller.fetchTerminationTypes();
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: _buildThemedDialogContent(
        title: "Terminate - ${employee.name}",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            /// Termination Date Field
            TextField(
              controller: terminationDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Termination Date",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.green, // header color
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      terminationDateController.text = DateFormat(
                        "yyyy-MM-dd",
                      ).format(picked);
                    }
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            /// Termination Type Dropdown
            Obx(() {
              if (controller.terminationTypes.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return DropdownButtonFormField<int>(
                value: selectedType.value == 0 ? null : selectedType.value,
                decoration: const InputDecoration(
                  labelText: "Termination Type",
                  border: OutlineInputBorder(),
                ),
                items: controller.terminationTypes.map((type) {
                  return DropdownMenuItem<int>(
                    value: type.id,
                    child: Text(type.name ?? ""),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) selectedType.value = val;
                },
              );
            }),
            const SizedBox(height: 12),

            /// Blacklist Dropdown
            Obx(() {
              return DropdownButtonFormField<bool>(
                value: isBlacklisted.value,
                decoration: const InputDecoration(
                  labelText: "Is Blacklisted?",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem<bool>(value: true, child: Text("Yes")),
                  DropdownMenuItem<bool>(value: false, child: Text("No")),
                ],
                onChanged: (val) {
                  if (val != null) isBlacklisted.value = val;
                },
              );
            }),
            const SizedBox(height: 12),

            /// Description Field
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // ✅ Validation Checks
                    if (terminationDateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a termination date ❌"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (selectedType.value == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a termination type ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a description ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    // ✅ If all valid — call API
                    controller.createTerminationController(
                      employeeId: int.parse(employee.employeeId!),
                      terminationDate: terminationDateController.text.trim(),
                      terminationType: selectedType.value,
                      description: descriptionController.text.trim(),
                      isblacklisted: isBlacklisted.value,
                    );

                    Get.back();

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text("Termination submitted successfully ✅"),
                    //     backgroundColor: Colors.green,
                    //     behavior: SnackBarBehavior.fixed,
                    //     duration: Duration(seconds: 2),
                    //   ),
                    // );
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Common dialog theme
Widget _buildThemedDialogContent({
  required Widget child,
  required String title,
}) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(padding: const EdgeInsets.all(8.0), child: child),
        ],
      ),
    ),
  );
}

/// EARLY LEAVE DIALOG ----->.....
// void _showEarlyLeaveDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) {
//   final dateController = TextEditingController();
//   final timeController = TextEditingController();
//   final reasonController = TextEditingController();
//
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       // firstDate: DateTime(2020),
//       // // lastDate: DateTime(2100),
//       // lastDate: DateTime.now(),
//       // initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       // lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green, // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: Colors.black, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green, // OK & Cancel button color
//               ),
//             ),
//           ),
//           child: child!, // original date picker with our theme
//         );
//       },
//     );
//     if (picked != null) {
//       dateController.text = DateFormat("yyyy-MM-dd").format(picked);
//     }
//   }
//
//   Future<void> _pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
//       timeController.text = DateFormat("HH:mm:ss").format(dt);
//     }
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: _buildThemedDialogContent(
//         title: "Early Leave - ${employee.name}",
//         child: Column(
//           children: [
//             TextField(
//               controller: dateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Date (yyyy-MM-dd)",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: _pickDate,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: timeController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Early Leave Time (HH:mm:ss)",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.access_time),
//                   onPressed: _pickTime,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: reasonController,
//               decoration: const InputDecoration(
//                 labelText: "Reason",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     if (employee.employeeId != null) {
//                       controller.updateEarlyLeavingController(
//                         empId: employee.employeeId.toString(),
//                         date: dateController.text.trim(),
//                         earlyLeaving: timeController.text.trim(),
//                         reason: reasonController.text.trim(),
//                       );
//                     } else {
//                       Get.snackbar("Error", "Employee ID not available");
//                     }
//                     Get.back();
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

void _showEarlyLeaveDialog(
  BuildContext context,
  EmployeeListController controller,
  Data employee,
) {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final reasonController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // OK & Cancel button color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      timeController.text = DateFormat("HH:mm:ss").format(dt);
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: _buildThemedDialogContent(
        title: "Early Leave - ${employee.name}",
        child: Column(
          children: [
            /// Date Picker
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

            /// Time Picker
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

            /// Reason Field
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // ✅ VALIDATION SECTION
                    if (employee.employeeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Employee ID not available ❌"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a date ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (timeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a time ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (reasonController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a reason ⚠️"),
                          backgroundColor: Colors.redAccent,

                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    // ✅ All validations passed
                    controller.updateEarlyLeavingController(
                      empId: employee.employeeId.toString(),
                      date: dateController.text.trim(),
                      earlyLeaving: timeController.text.trim(),
                      reason: reasonController.text.trim(),
                    );

                    Get.back();

                    // ✅ Success Snackbar (bottom)
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text("Early leave submitted successfully ✅"),
                    //     backgroundColor: Colors.green,
                    //     behavior: SnackBarBehavior.fixed,
                    //     duration: Duration(seconds: 2),
                    //   ),
                    // );
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// OverTime Dialog Here ------>>>>
// void _showOverTimeDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) {
//   final dateController2 = TextEditingController();
//   final reasonController2 = TextEditingController();
//   int selectedHour = 1; // default 1 hour
//
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       // lastDate: DateTime(2100),
//       lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//       // firstDate: DateTime.now(),
//       // lastDate: DateTime(2100),
//       // // lastDate: DateTime.now(),
//       // initialDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green, // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: Colors.black, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green, // OK & Cancel button color
//               ),
//             ),
//           ),
//           child: child!, // original date picker with our theme
//         );
//       },
//     );
//     if (picked != null) {
//       dateController2.text = DateFormat("yyyy-MM-dd").format(picked);
//     }
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Overtime - ${employee.name}",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Date Picker
//             TextField(
//               controller: dateController2,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Date (yyyy-MM-dd)",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: _pickDate,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             /// Hours Picker Dropdown
//             DropdownButtonFormField<int>(
//               value: selectedHour,
//               decoration: const InputDecoration(
//                 labelText: "Overtime (hours)",
//                 border: OutlineInputBorder(),
//               ),
//               items:
//                   List.generate(24, (index) => index + 1) // 1 to 24 hours
//                       .map(
//                         (hour) => DropdownMenuItem(
//                           value: hour,
//                           child: Text("$hour hr${hour > 1 ? 's' : ''}"),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (val) {
//                 if (val != null) selectedHour = val;
//               },
//             ),
//             const SizedBox(height: 12),
//
//             /// Reason
//             TextField(
//               controller: reasonController2,
//               decoration: const InputDecoration(
//                 labelText: "Reason",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     if (employee.employeeId != null) {
//                       final overtimeText =
//                           selectedHour.toString().padLeft(2, '0') + ":00:00";
//
//                       controller.updateOverTimeController(
//                         empId: employee.employeeId.toString(),
//                         date: dateController2.text.trim(),
//                         overtime: overtimeText,
//                         reason: reasonController2.text.trim(),
//                       );
//                     } else {
//                       Get.snackbar("Error", "Employee ID not available");
//                     }
//                     Get.back();
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// void _showOverTimeDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) {
//   final dateController2 = TextEditingController();
//   final reasonController2 = TextEditingController();
//   int selectedHour = 1; // default 1 hour
//
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(foregroundColor: Colors.green),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       dateController2.text = DateFormat("yyyy-MM-dd").format(picked);
//     }
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Overtime - ${employee.name}",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Date Picker
//             TextField(
//               controller: dateController2,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Date (yyyy-MM-dd)",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: _pickDate,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             /// Hours Picker Dropdown
//             DropdownButtonFormField<int>(
//               value: selectedHour,
//               decoration: const InputDecoration(
//                 labelText: "Overtime (hours)",
//                 border: OutlineInputBorder(),
//               ),
//               items: List.generate(24, (index) => index + 1)
//                   .map(
//                     (hour) => DropdownMenuItem(
//                       value: hour,
//                       child: Text("$hour hr${hour > 1 ? 's' : ''}"),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) selectedHour = val;
//               },
//             ),
//             const SizedBox(height: 12),
//
//             /// Reason Field
//             TextField(
//               controller: reasonController2,
//               decoration: const InputDecoration(
//                 labelText: "Reason",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             /// Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     // ✅ VALIDATION SECTION
//                     if (employee.employeeId == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Employee ID not available ❌"),
//                           backgroundColor: Colors.redAccent,
//                           behavior: SnackBarBehavior.floating,
//                           margin: EdgeInsets.only(
//                             bottom: 16,
//                             left: 16,
//                             right: 16,
//                           ),
//                         ),
//                       );
//                       return;
//                     }
//
//                     if (dateController2.text.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Please select a date ⚠️"),
//                           backgroundColor: Colors.redAccent,
//                           behavior: SnackBarBehavior.floating,
//                           margin: EdgeInsets.only(
//                             bottom: 16,
//                             left: 16,
//                             right: 16,
//                           ),
//                         ),
//                       );
//                       return;
//                     }
//
//                     if (reasonController2.text.trim().isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Please enter a reason ⚠️"),
//                           backgroundColor: Colors.redAccent,
//                           behavior: SnackBarBehavior.floating,
//                           margin: EdgeInsets.only(
//                             bottom: 16,
//                             left: 16,
//                             right: 16,
//                           ),
//                         ),
//                       );
//                       return;
//                     }
//
//                     // ✅ If all validations passed
//                     final overtimeText =
//                         selectedHour.toString().padLeft(2, '0') + ":00:00";
//
//                     controller.updateOverTimeController(
//                       empId: employee.employeeId.toString(),
//                       date: dateController2.text.trim(),
//                       overtime: overtimeText,
//                       reason: reasonController2.text.trim(),
//                     );
//
//                     Get.back();
//
//                     // ✅ Success Snackbar
//                     // ScaffoldMessenger.of(context).showSnackBar(
//                     //   const SnackBar(
//                     //     content: Text("Overtime submitted successfully ✅"),
//                     //     backgroundColor: Colors.green,
//                     //     behavior: SnackBarBehavior.fixed,
//                     //     duration: Duration(seconds: 2),
//                     //   ),
//                     // );
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
void _showOverTimeDialog(
  BuildContext context,
  EmployeeListController controller,
  Data employee,
) {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final reasonController = TextEditingController();

  // 🔹 Date Picker
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }

  // 🔹 Time Picker (for hours, minutes, and seconds)
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      timeController.text = DateFormat("HH:mm:ss").format(dt);
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: _buildThemedDialogContent(
        title: "Overtime - ${employee.name}",
        child: Column(
          children: [
            /// Date Picker
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

            /// Time Picker (HH:mm:ss)
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Overtime Duration (HH:mm:ss)",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: _pickTime,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            /// Reason Field
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // ✅ VALIDATION SECTION
                    if (employee.employeeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Employee ID not available ❌"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a date ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (timeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select overtime duration ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (reasonController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a reason ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    // ✅ All validations passed
                    controller.updateOverTimeController(
                      empId: employee.employeeId.toString(),
                      date: dateController.text.trim(),
                      overtime: timeController.text.trim(),
                      reason: reasonController.text.trim(),
                    );

                    Get.back();

                    // ✅ Success Snackbar (bottom)
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text("Overtime submitted successfully ✅"),
                    //     backgroundColor: Colors.green,
                    //     behavior: SnackBarBehavior.fixed,
                    //     duration: Duration(seconds: 2),
                    //   ),
                    // );
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// MANAGE ATTENDANCE DIALOG ------->>>>>>
// void _showManageAttendanceDialog(
//   BuildContext context,
//   EmployeeListController controller,
//   Data employee,
// ) {
//   final dateController = TextEditingController();
//   final timeController = TextEditingController();
//   final reasonController = TextEditingController();
//   final statusController = ValueNotifier<String>("Present");
//
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2025),
//       // lastDate: DateTime(2125),
//       lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green, // header background color
//               onPrimary: Colors.white, // header text color
//               onSurface: Colors.black, // body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.green, // OK & Cancel button color
//               ),
//             ),
//           ),
//           child: child!, // original date picker with our theme
//         );
//       },
//     );
//     if (picked != null) {
//       dateController.text = DateFormat("yyyy-MM-dd").format(picked);
//     }
//   }
//
//   Future<void> _pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
//       timeController.text = DateFormat("HH:mm:ss").format(dt);
//     }
//   }
//
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       backgroundColor: Colors.white,
//       child: _buildThemedDialogContent(
//         title: "Manage Attendance - ${employee.name}",
//         child: Column(
//           children: [
//             TextField(
//               controller: dateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: "Date (yyyy-MM-dd)",
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: _pickDate,
//                 ),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ValueListenableBuilder<String>(
//               valueListenable: statusController,
//               builder: (context, value, _) {
//                 return Column(
//                   children: [
//                     if (value == "Present") ...[
//                       TextField(
//                         controller: timeController,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: "Time (HH:mm:ss)",
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.access_time),
//                             onPressed: _pickTime,
//                           ),
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("Status:"),
//                         DropdownButton<String>(
//                           value: value,
//                           items: const [
//                             DropdownMenuItem(
//                               value: "Present",
//                               child: Text(
//                                 "Present",
//                                 style: TextStyle(color: Colors.green),
//                               ),
//                             ),
//                             DropdownMenuItem(
//                               value: "Absent",
//                               child: Text(
//                                 "Absent",
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             ),
//                           ],
//                           onChanged: (val) {
//                             if (val != null) statusController.value = val;
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     if (value == "Absent")
//                       TextField(
//                         controller: reasonController,
//                         decoration: const InputDecoration(
//                           labelText: "Reason for Absence",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Cancel"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     if (employee.employeeId != null) {
//                       controller.markAttendanceController(
//                         empId: employee.employeeId.toString(),
//                         date: dateController.text.trim(),
//                         timestamp: statusController.value == "Present"
//                             ? "${dateController.text.trim()} ${timeController.text.trim()}"
//                             : null,
//                         status: statusController.value,
//                         reason: statusController.value == "Absent"
//                             ? reasonController.text.trim()
//                             : null,
//                       );
//                     } else {
//                       Get.snackbar("Error", "Employee ID not available");
//                     }
//                     Get.back();
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

void _showManageAttendanceDialog(
  BuildContext context,
  EmployeeListController controller,
  Data employee,
) {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final reasonController = TextEditingController();
  final statusController = ValueNotifier<String>("Present");

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      timeController.text = DateFormat("HH:mm:ss").format(dt);
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: _buildThemedDialogContent(
        title: "Manage Attendance - ${employee.name}",
        child: Column(
          children: [
            /// Date
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

            /// Attendance Fields
            ValueListenableBuilder<String>(
              valueListenable: statusController,
              builder: (context, value, _) {
                return Column(
                  children: [
                    if (value == "Present") ...[
                      TextField(
                        controller: timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Time (HH:mm:ss)",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: _pickTime,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status:"),
                        DropdownButton<String>(
                          value: value,
                          items: const [
                            DropdownMenuItem(
                              value: "Present",
                              child: Text(
                                "Present",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Absent",
                              child: Text(
                                "Absent",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) statusController.value = val;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (value == "Absent")
                      TextField(
                        controller: reasonController,
                        decoration: const InputDecoration(
                          labelText: "Reason for Absence",
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // ✅ Validation Section
                    if (employee.employeeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Employee ID not available ❌"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a date ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (statusController.value == "Present" &&
                        timeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a time ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    if (statusController.value == "Absent" &&
                        reasonController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a reason ⚠️"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                            right: 16,
                          ),
                        ),
                      );
                      return;
                    }

                    // ✅ All validations passed
                    controller.markAttendanceController(
                      empId: employee.employeeId.toString(),
                      date: dateController.text.trim(),
                      timestamp: statusController.value == "Present"
                          ? "${dateController.text.trim()} ${timeController.text.trim()}"
                          : null,
                      status: statusController.value,
                      reason: statusController.value == "Absent"
                          ? reasonController.text.trim()
                          : null,
                    );

                    Get.back();

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       "Attendance marked as ${statusController.value} ✅",
                    //     ),
                    //     backgroundColor: Colors.green,
                    //     behavior: SnackBarBehavior.floating,
                    //     margin: const EdgeInsets.only(
                    //       bottom: 16,
                    //       left: 16,
                    //       right: 16,
                    //     ),
                    //   ),
                    // );
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
