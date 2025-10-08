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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  _showEmployeeSearchDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add, color: Colors.white, size: 25),
                    SizedBox(width: 5),
                    Text(
                      "Register an Employee",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

        
          // Check-in Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [_buildActionTile("Check-in")],
            ),
          ),

          const SizedBox(height: 10),
// ✅ Attendance Date Display + Change Option
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        DateFormat('yyyy-MM-dd').format(selectedDate),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.calendar_today, color: Colors.green),
        onPressed: () async {
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
      ),
    ],
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

  Widget _buildActionTile(String label) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
            if (label == "Check-in") {
              _showEmployeeAttendanceDialog(context);
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: Colors.white)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 35,
                  width: 35,
                  child: const Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ],
            ),
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
