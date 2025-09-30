import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../RegisterEmployee/RegisterEmployee.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.listtController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// Register Employee Button
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
                  Get.to(RegisterEmployeeScreen());
                  debugPrint("Register employee clicked");
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

          /// Check-in & Check-out Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 10,
              children: [
                _buildActionTile("Check-in"),
                _buildActionTile("Check-out"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Employee List Section (API data show)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMs.isNotEmpty) {
                return Center(child: Text(controller.errorMs.value));
              }

              if (controller.employeelisttt.isEmpty) {
                return const Center(child: Text("No employees found"));
              }

              return EmployeeListWidget(
                employeelist: controller.employeelisttt,
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Custom tile builder for Check-in / Check-out
  Widget _buildActionTile(String label) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
            debugPrint("$label tapped");
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
}
