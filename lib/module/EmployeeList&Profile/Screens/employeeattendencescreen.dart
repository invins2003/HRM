import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/EmployeeListController/EmployeeListController.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  final String empId;
  const EmployeeAttendanceScreen({super.key, required this.empId});

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  final EmployeeListController controller = Get.put(
    EmployeeListController(employeeListRepo: Get.find()),
  );

  DateTime selectedMonth = DateTime.now();
  RxString filterStatus = "".obs;

  late int selectedYear;
  late int selectedMonthIndex;

  final List<String> months = List.generate(12, (index) {
    return DateFormat.MMMM().format(DateTime(0, index + 1));
  });

  late List<int> years;

  @override
  void initState() {
    super.initState();
    selectedYear = selectedMonth.year;
    selectedMonthIndex = selectedMonth.month - 1;

    int currentYear = DateTime.now().year;
    years = List.generate(5, (i) => currentYear - i); // Last 5 years

    fetchAttendance();
  }

  void fetchAttendance() {
    controller.fetchEmployeeAttendance(
      widget.empId,
      selectedMonthIndex + 1,
      selectedYear,
    );
    filterStatus.value = "";
  }

  void toggleFilter(String status) {
    filterStatus.value = filterStatus.value == status ? "" : status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Attendance"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Month & Year dropdowns
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text("Month: "),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: months[selectedMonthIndex],
                  items: months
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMonthIndex = months.indexOf(value);
                        selectedMonth = DateTime(
                          selectedYear,
                          selectedMonthIndex + 1,
                        );
                      });
                      fetchAttendance();
                    }
                  },
                ),
                const SizedBox(width: 16),
                const Text("Year: "),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: selectedYear,
                  items: years
                      .map((y) => DropdownMenuItem(value: y, child: Text("$y")))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYear = value;
                        selectedMonth = DateTime(
                          selectedYear,
                          selectedMonthIndex + 1,
                        );
                      });
                      fetchAttendance();
                    }
                  },
                ),
              ],
            ),
          ),

          // Attendance summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Obx(() {
              int presentCount = controller.attendanceList
                  .where((e) => e.status == "Present")
                  .length;
              int absentCount = controller.attendanceList
                  .where((e) => e.status == "Absent")
                  .length;

              return Row(
                children: [
                  _buildSummaryBox(
                    "Present",
                    presentCount,
                    Colors.green,
                    filterStatus.value == "Present",
                    onTap: () => toggleFilter("Present"),
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryBox(
                    "Absent",
                    absentCount,
                    Colors.redAccent,
                    filterStatus.value == "Absent",
                    onTap: () => toggleFilter("Absent"),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 12),

          // Attendance list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingAttendance.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.attendanceList.isEmpty) {
                return const Center(child: Text("No attendance records found"));
              }

              final displayedList = filterStatus.value.isEmpty
                  ? controller.attendanceList
                  : controller.attendanceList
                        .where((e) => e.status == filterStatus.value)
                        .toList();

              if (displayedList.isEmpty) {
                return Center(
                  child: Text(
                    "No ${filterStatus.value} records found for this month",
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => fetchAttendance(),
                color: Colors.green,
                backgroundColor: Colors.white,
                child: ListView.separated(
                  itemCount: displayedList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 1),
                  itemBuilder: (context, index) {
                    final record = displayedList[index];
                    final isPresent = record.status == "Present";
                    final statusColor = isPresent
                        ? Colors.green
                        : Colors.redAccent;

                    String formattedDate = record.date != null
                        ? DateFormat(
                            'EEE, dd MMM yyyy',
                          ).format(DateTime.parse(record.date!))
                        : 'N/A';

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: statusColor, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: statusColor,
                                child: Icon(
                                  isPresent ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Status: ${record.status}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isPresent
                                            ? Colors.green[800]
                                            : Colors.redAccent[700],
                                      ),
                                    ),
                                    if (record.reason != null &&
                                        record.reason!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2.0,
                                        ),
                                        child: Text(
                                          "Reason: ${record.reason}",
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isPresent) ...[
                            const Divider(height: 20, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.login,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text("${record.clockIn!.split(' ').last}"),
                                  ],
                                ),
                                if (record.clockOut!.split(' ').last != '00:00:00')
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    
                                    Text("${record.clockOut!.split(' ').last}"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (record.late != null &&
                                    record.late != '00:00:00')
                                  _buildInfoChip("Late", record.late),
                                if (record.earlyLeaving != null &&
                                    record.earlyLeaving != '00:00:00')
                                  _buildInfoChip(
                                    "Early Leaving",
                                    record.earlyLeaving,
                                  ),
                                if (record.overtime != null &&
                                    record.overtime != '00:00:00')
                                  _buildInfoChip("Overtime", record.overtime),
                              ],
                            ),
                            if (record.shift != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Shift: ${record.shift!.title} (${record.shift!.startTime}-${record.shift!.endTime})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(
    String title,
    int count,
    Color color,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Column(
            children: [
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 14, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String title, String? value) {
    return Chip(
      label: Text("$title: ${value ?? '00:00:00'}"),
      backgroundColor: Colors.grey[200],
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }
}
