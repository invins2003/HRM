import 'package:erp_admin/module/DashBoard/Model/present_employee_model.dart';
import 'package:flutter/material.dart';
import 'Model/EmployeesLIstModel.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<AttendanceData> employeelist;

  const EmployeeListWidget({super.key, required this.employeelist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Employee Attendence List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: employeelist.length,
            separatorBuilder: (context, index) => const SizedBox(height: 2),
            itemBuilder: (context, index) {
              final employee = employeelist[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: Text(
                    employee.employee?.employeeId != null && employee.employee!.name!.isNotEmpty
                        ? employee.employee!.name![0].toUpperCase()
                        : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(employee.employee!.name ?? "No Name"),
                subtitle: Text("ID: ${employee.employee?.employeeId ?? "N/A"}"),
                trailing: Text(
                  employee.clockIn ?? "No Email",
                  style: TextStyle(
                    color:
                        (employee.clockIn != null && employee.clockIn!.isNotEmpty)
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  debugPrint(
                    "Tapped on ${employee.employee?.employeeId} (${employee.employee?.employeeId})",
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
