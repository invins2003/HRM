import 'package:erp_admin/module/DashBoard/Controller/EmployeeListController.dart';
import 'package:flutter/material.dart';
import 'package:erp_admin/module/DashBoard/Model/present_employee_model.dart';
import 'package:get/get.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<AttendanceData> presentemployeelist;

  const EmployeeListWidget({super.key, required this.presentemployeelist});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashBoardEmployeeList>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Subtle scale factors (keeps same look)
    final scale = isTablet ? 1.15 : 1.0;
    final fontScale = isTablet ? 1.1 : 1.0;

    // ✅ Count totals
    final totalEmployees = controller.employeelisttt
        .where((e) => (e.isActive == true))
        .length
        .toString();
    final totalPresent = presentemployeelist
        .where((e) => (e.status?.toLowerCase() ?? '') == 'present')
        .length;
    final totalAbsent = presentemployeelist
        .where((e) => (e.status?.toLowerCase() ?? '') == 'absent')
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0 * scale),
          child: Text(
            "Employee Attendance List",
            style: TextStyle(
              fontSize: 18 * fontScale,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // ✅ Summary Cards Row (kept same layout)
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 8.0 * scale, vertical: 8 * scale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(
                title: "Total",
                value: totalEmployees,
                color: Colors.blue,
                bgColor: Colors.blue.shade50,
                fontScale: fontScale,
                scale: scale,
              ),
              SizedBox(width: 10 * scale),
              _buildSummaryCard(
                title: "Present",
                value: totalPresent.toString(),
                color: Colors.green,
                bgColor: Colors.green.shade50,
                fontScale: fontScale,
                scale: scale,
              ),
              SizedBox(width: 10 * scale),
              _buildSummaryCard(
                title: "Absent",
                value: totalAbsent.toString(),
                color: Colors.red,
                bgColor: Colors.red.shade50,
                fontScale: fontScale,
                scale: scale,
              ),
            ],
          ),
        ),

        // ✅ Employee List Section
        Expanded(
          child: presentemployeelist.isEmpty
              ? _buildEmptyState(controller, fontScale, scale)
              : ListView.separated(
                  padding:
                      EdgeInsets.symmetric( vertical: 4),
                  itemCount: presentemployeelist.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 1),
                  itemBuilder: (context, index) {
                    final employee = presentemployeelist[index];
                    final status = employee.status?.toLowerCase() ?? "absent";
                    final isPresent = status == "present";

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 22 * scale,
                        backgroundColor:
                            isPresent ? Colors.green : Colors.red,
                        child: Text(
                          (employee.employee?.name ?? "?")
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * fontScale,
                          ),
                        ),
                      ),
                      title: Text(
                        employee.employee?.name ?? "No Name",
                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        "ID: ${employee.employee?.employeeId ?? "N/A"} | Type: ${employee.employee?.employeeType ?? "N/A"}",
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Text(
                        employee.status ?? "Absent",
                        style: TextStyle(
                          color: isPresent ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// ✅ Empty State (same look)
  Widget _buildEmptyState(
      DashBoardEmployeeList controller, double fontScale, double scale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline,
              color: Colors.grey, size: 60 * scale),
          SizedBox(height: 10 * scale),
          Text(
            "No employees found",
            style: TextStyle(
              fontSize: 16 * fontScale,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 15 * scale),
          ElevatedButton.icon(
            onPressed: () async {
              await controller.listtController();
              await controller.presentListtController(DateTime.now());
            },
            icon: Icon(Icons.refresh, size: 20 * scale),
            label: Text(
              "Retry",
              style: TextStyle(fontSize: 14 * fontScale),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 12 * scale,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Summary Card (same look, small scale tweak)
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
    required double fontScale,
    required double scale,
  }) {
    return Expanded(
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * scale),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(12.0 * scale),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15 * fontScale,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: 6 * scale),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
