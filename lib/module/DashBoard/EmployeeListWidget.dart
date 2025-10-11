import 'package:erp_admin/module/DashBoard/Controller/EmployeeListController.dart';
import 'package:flutter/material.dart';
import 'package:erp_admin/module/DashBoard/Model/present_employee_model.dart';
import 'package:get/get.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<AttendanceData> employeelist;

  const EmployeeListWidget({super.key, required this.employeelist});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardEmployeeList>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Employee Attendance List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // ✅ Remove nested refresh indicator
        Expanded(
          child: employeelist.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline,
                          color: Colors.grey, size: 60),
                      const SizedBox(height: 10),
                      const Text(
                        "No employees found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await controller.listtController();
                          await controller.presentListtController(
                              DateTime.now());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: employeelist.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 1),
                  itemBuilder: (context, index) {
                    final employee = employeelist[index];
                    final status = employee.status?.toLowerCase() ?? "absent";
                    final isPresent = status == "present";

                    return Dismissible(
                      key: Key(employee.id.toString()),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Confirm Delete"),
                            content: Text(
                              "Do you want to delete attendance for ${employee.employee?.name ?? "this employee"}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        controller.deleteEmployeeAttendance(
                            employee.id.toString());
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isPresent ? Colors.green : Colors.red,
                          child: Text(
                            (employee.employee?.name ?? "?")
                                .substring(0, 1)
                                .toUpperCase(),
                            style:
                                const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(employee.employee?.name ?? "No Name"),
                        subtitle: Text(
                          "ID: ${employee.employee?.employeeId ?? "N/A"} | Type: ${employee.employee?.employeeType ?? "N/A"}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Text(
                          employee.status ?? "Absent",
                          style: TextStyle(
                            color: isPresent ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
