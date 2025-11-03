import 'dart:math';
import 'package:camera/camera.dart';
import 'package:erp_admin/common/faceattendence.dart'; // Make sure this path is correct for FaceProcessingScreen
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/RegisterEmployee/screens/RegisterEmployee.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/EmployeeListController.dart';
import '../EmployeeListWidget.dart';

// Import your FaceProcessingScreen
// import 'package:erp_admin/path/to/FaceProcessingScreen.dart';

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
  // ✅ _isProcessing flag is NO LONGER NEEDED here.
  // The FaceProcessingScreen will handle its own UI state.

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.listtController();
      controller.presentListtController(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Stack is no longer needed unless you add the loader back for other reasons
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeSearchDialog(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: Column(
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
    );
  }

  // --- Widgets ---
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

  Widget _buildEmployeeList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMs.isNotEmpty) {
        return Center(
          child: Text(controller.errorMs.value,
              style: const TextStyle(color: Colors.red)),
        );
      }

      if (controller.attendanceList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              const Text("No employees found",
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
        child: EmployeeListWidget(presentemployeelist: controller.attendanceList),
      );
    });
  }

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

  // --- Employee Search Dialog (for registration only) ---
  void _showEmployeeSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<Data> filteredList = controller.employeelisttt
        .where((emp) =>
            emp.isActive == true &&
            (emp.biometricEmpId == null || emp.biometricEmpId!.isEmpty))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Select the Employee"),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Enter employee name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredList = controller.employeelisttt
                            .where((emp) =>
                                emp.isActive == true &&
                                (emp.name ?? "")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text("No active employee found"))
                        : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final employee = filteredList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(
                                    employee.name!.isNotEmpty
                                        ? employee.name![0].toUpperCase()
                                        : "?",
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(employee.name ?? "No Name"),
                                subtitle: Text(
                                    "ID: ${employee.employeeId ?? 'N/A'}"),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (employee.biometricEmpId != null &&
                                      employee.biometricEmpId!.isNotEmpty) {
                                    Get.snackbar(
                                      "Already Registered",
                                      "${employee.name} is already registered.",
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    Get.to(() => RegisterEmployeeScreen(
                                          employee: employee,
                                        ));
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        });
      },
    );
  }

  // --- Automatic Face Matching (MODIFIED) ---
  Future<void> _handleAutoAttendance(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      // Default to front camera
      final firstCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Get the list of registered employees BEFORE opening the camera
      final List<Data> allEmployees = controller.employeelisttt
          .where((e) =>
              e.isActive == true &&
              e.biometricEmpId != null &&
              e.biometricEmpId!.isNotEmpty)
          .toList();

      if (allEmployees.isEmpty) {
        Get.snackbar(
          "No Registered Employees",
          "Please register an employee's face first.",
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Navigate to the continuous scanning screen.
      // Pass the camera, the employee list, and the controller.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FaceProcessingScreen(
            camera: firstCamera,
            allEmployees: allEmployees,
            controller: controller,
          ),
        ),
      );

      // After the camera screen is closed (e.g., user presses back),
      // refresh the present list.
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
    // NO 'finally' block or _isProcessing logic needed here anymore.
  }

  // _cosineSimilarity is no longer needed here.
  // It will be moved to FaceProcessingScreen.
}