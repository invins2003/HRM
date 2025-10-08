import 'dart:math';
import 'package:camera/camera.dart';
import 'package:erp_admin/common/faceattendence.dart';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // ✅ for formatting date
import '../../RegisterEmployee/screens/RegisterEmployee.dart';
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

  DateTime selectedDate = DateTime.now(); // ✅ default today

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Register Employee Button
          _buildRegisterEmployeeButton(),

        
          // Check-in Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [_buildActionTile("Check-in")],
            ),
          ),

          const SizedBox(height: 10),
/// ✅ Attendance Date Display + Change Option
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: InkWell(
    onTap: () async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2025),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });

        // 🔄 Refresh attendance list when date changes
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
              const Icon(Icons.calendar_today, color: Colors.green, size: 20),
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
),


          // Employee List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMs.isNotEmpty) {
                return Center(child: Text(controller.errorMs.value));
              }

              if (controller.attendanceList.isEmpty) {
                return const Center(child: Text("No employees found"));
              }

              return RefreshIndicator(
                color: Colors.green,
                backgroundColor: Colors.white,
      onRefresh: () async {
        await controller.listtController();
        await controller.presentListtController(selectedDate);
      },
      child: EmployeeListWidget(
        employeelist: controller.attendanceList,
      ),
    );
            }),
          ),
        ],
      ),
    );
  }
  Widget _buildRegisterEmployeeButton() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: GestureDetector(
      onTap: () {
        _showEmployeeSearchDialog(context);
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF1B5E20)], // Green shades
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            const Text(
              "Register an Employee",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildActionTile(String label) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        if (label == "Check-in") {
          _showEmployeeAttendanceDialog(context);
        }
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    ),
  );
}


  void _showEmployeeSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<Data> filteredList = controller.employeelisttt;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Select the Employee"),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            .where((emp) => (emp.name ?? "")
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text("No employee found"))
                        : ListView.builder(
                            shrinkWrap: true,
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(employee.name ?? "No Name"),
                                subtitle:
                                    Text("ID: ${employee.employeeId ?? 'N/A'}"),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (employee.biometricEmpId != null &&
                                      employee.biometricEmpId!.isNotEmpty) {
                                    Get.snackbar(
                                      "Already Registered",
                                      "${employee.name} is already registered for face recognition.",
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

  void _showEmployeeAttendanceDialog(BuildContext context) async {
    final searchController = TextEditingController();
    List<Data> filteredList = controller.employeelisttt;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Select Employee"),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                            .where((emp) => (emp.name ?? "")
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text("No employee found"))
                        : ListView.builder(
                            shrinkWrap: true,
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(employee.name ?? "No Name"),
                                subtitle:
                                    Text("ID: ${employee.employeeId ?? 'N/A'}"),
                                onTap: () async {
                                  Navigator.pop(context);
                                  final cameras = await availableCameras();
                                  final firstCamera = cameras.first;

                                  final liveEmbeddings =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FaceProcessingScreen(
                                        camera: firstCamera,
                                        maxCaptures: 1,
                                      ),
                                    ),
                                  );

                                  if (liveEmbeddings != null &&
                                      liveEmbeddings.isNotEmpty) {
                                    _checkFaceMatch(
                                        employee, liveEmbeddings.first);
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

  void _checkFaceMatch(Data employee, List<double> liveEmbedding) async {
    final stored = employee.biometricEmpId;

    if (stored == null || stored.isEmpty) {
      Get.snackbar(
        "Not Registered",
        "${employee.name} has no registered face ❌",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Convert stored embeddings safely
      final storedEmbeddings = stored
          .map<List<double>>(
              (e) => (e as List).map<double>((v) => v.toDouble()).toList())
          .toList();

      bool matched = false;
      for (var s in storedEmbeddings) {
        if (_cosineSimilarity(liveEmbedding, s) >= 0.6) {
          matched = true;
          break;
        }
      }

      if (matched) {
        // ✅ Local face match success
        Get.snackbar(
          "Face Matched",
          "${employee.name} face matched ✅",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // 🔄 Call API via controller
        await controller.verifyAttendance(
            liveEmbedding, employee.employeeId.toString());
      } else {
        Get.snackbar(
          "Check-in Failed",
          "${employee.name} face did not match ❌",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, st) {
      debugPrint("Error processing embeddings: $e\n$st");
      Get.snackbar(
        "Error",
        "Could not process face embeddings",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    assert(a.length == b.length);
    double dot = 0.0, normA = 0.0, normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    return dot / (sqrt(normA) * sqrt(normB));
  }
}
