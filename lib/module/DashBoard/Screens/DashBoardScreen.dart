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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [_buildActionTile("Check-in")]),
            ),
            const SizedBox(height: 10),
            _buildDatePicker(context),
            Expanded(child: _buildEmployeeList(context)),
          ],
        ),
      ),
    );
  }

  // ---------------- Date Picker ----------------
  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.edit_calendar, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Employee List ----------------
  Widget _buildEmployeeList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMs.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMs.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (controller.attendanceList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              const Text("No attendance records found",
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.listtController();
                  await controller.presentListtController(selectedDate);
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
  Widget _buildActionTile(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == "Check-in") _handleAutoAttendance(context);
        },
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                "Check-in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
