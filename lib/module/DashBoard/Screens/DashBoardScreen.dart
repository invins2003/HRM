import 'package:camera/camera.dart';
import 'package:erp_admin/common/faceattendence.dart';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/EmployeeListController.dart';
import '../EmployeeListWidget.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final controller = Get.put(
    DashBoardEmployeeList(employeeListRepo: Get.find()),
  );

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await controller.listtController();
      await controller.presentListtController(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 MediaQuery for responsive UI
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 20.0 : 10.0;
    final fontSize = isTablet ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              SizedBox(height: isTablet ? 30 : 20),
              Row(
                children: [
                  _buildActionTile("Check-in", fontSize, isTablet),
                ],
              ),
              SizedBox(height: isTablet ? 30 : 20),
              _buildDatePicker(context, fontSize, isTablet),
              SizedBox(height: isTablet ? 40 : 30),
              Expanded(child: _buildEmployeeList(context, isTablet)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Date Picker ----------------
  Widget _buildDatePicker(BuildContext context, double fontSize, bool isTablet) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() => selectedDate = pickedDate);
          await controller.listtController();
          await controller.presentListtController(pickedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          border: Border.all(color: Colors.green.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.green, size: isTablet ? 26 : 20),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(Icons.edit_calendar,
                color: Colors.green, size: isTablet ? 26 : 22),
          ],
        ),
      ),
    );
  }

  // ---------------- Employee List ----------------
  Widget _buildEmployeeList(BuildContext context, bool isTablet) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMs.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMs.value,
            style: TextStyle(
              color: Colors.red,
              fontSize: isTablet ? 18 : 14,
            ),
          ),
        );
      }

      if (controller.attendanceList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline,
                  size: isTablet ? 100 : 60, color: Colors.grey),
              SizedBox(height: isTablet ? 20 : 10),
              Text(
                "No attendance records found",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: isTablet ? 25 : 15),
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.listtController();
                  await controller.presentListtController(selectedDate);
                },
                icon: Icon(Icons.refresh, size: isTablet ? 24 : 20),
                label: Text(
                  "Retry",
                  style: TextStyle(fontSize: isTablet ? 18 : 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 16 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: Colors.green,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await controller.listtController();
          await controller.presentListtController(selectedDate);
        },
        child: EmployeeListWidget(
          presentemployeelist: controller.attendanceList,
        ),
      );
    });
  }

  // ---------------- Check-in Button ----------------
  Widget _buildActionTile(String label, double fontSize, bool isTablet) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == "Check-in") _handleAutoAttendance(context);
        },
        child: Container(
          height: isTablet ? 100 : 80,
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 8,
            vertical: isTablet ? 10 : 6,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified,
                  color: Colors.white, size: isTablet ? 36 : 28),
              SizedBox(width: isTablet ? 14 : 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Face Check-in ----------------
  Future<void> _handleAutoAttendance(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final List<Data> allEmployees = controller.employeelisttt
          .where((e) =>
              e.isActive == true &&
              e.biometricEmpId != null &&
              e.biometricEmpId!.isNotEmpty)
          .toList();

      if (allEmployees.isEmpty) {
        Get.snackbar(
          "No Registered Faces",
          "Please ensure some employees have registered faces.",
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FaceProcessingScreen(
            camera: frontCamera,
            allEmployees: allEmployees,
            controller: controller,
          ),
        ),
      );

      await controller.presentListtController(selectedDate);
    } catch (e, st) {
      debugPrint("Error in auto check-in: $e\n$st");
      Get.snackbar(
        "Error",
        "Could not open camera. Check permissions.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
