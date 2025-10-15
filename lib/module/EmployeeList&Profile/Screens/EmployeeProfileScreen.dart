import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeProfileController/EmployeeProfileController.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final int employeeId;

  const EmployeeProfileScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final EmployeeProfileController controller = Get.put(
      EmployeeProfileController(employeeProfileRepo: Get.find()),
    );

    controller.profileController(employeeId);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Employee Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.Profiledata.value.data == null) {
          return const Center(
            child: Text(
              "No Profile Data Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        final profile = controller.Profiledata.value.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              /// Profile Avatar
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.green.shade300,
                child: const Icon(Icons.person, color: Colors.white, size: 55),
              ),
              const SizedBox(height: 16),

              /// Name
              Text(
                profile?.name ?? "--",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),

              /// Designation
              Text(
                profile?.designation?.name ?? "--",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 25),

              /// Info Cards
              _infoCard(
                icon: Icons.badge,
                title: "Employee ID",
                value: profile?.employeeId?.toString() ?? "--",
              ),
              _infoCard(
                icon: Icons.email,
                title: "Email",
                value: profile?.email ?? "--",
              ),
              _infoCard(
                icon: Icons.phone,
                title: "Mobile",
                value: profile?.phone ?? "--",
              ),
              _infoCard(
                icon: Icons.account_tree,
                title: "Department",
                value: profile?.department?.name ?? "--",
              ),
              _infoCard(
                icon: Icons.work,
                title: "Designation",
                value: profile?.designation?.name ?? "--",
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Custom Rounded Info Card
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ),
    );
  }
}