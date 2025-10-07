import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Controller/EmployeeProfileController/EmployeeProfileController.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final int employeeId;

  const EmployeeProfileScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final EmployeeProfileController controller = Get.put(
      EmployeeProfileController(employeeProfileRepo: Get.find()),
    );

    // API call
    controller.profileController(employeeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Employee Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
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
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// Avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green.shade400,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Details in ListTile format
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.green),
                  title: const Text("Employee ID"),
                  subtitle: Text(profile?.employeeId?.toString() ?? "--"), // ✅ FIXED
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text("Name"),
                  subtitle: Text(profile?.name?.toString() ?? "--"), // ✅ SAFE
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text("Email"),
                  subtitle: Text(profile?.email?.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text("Mobile"),
                  subtitle: Text(profile?.phone?.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.account_tree, color: Colors.green),
                  title: const Text("Department"),
                  subtitle: Text(profile?.department?.name.toString() ?? "--"),
                ),
                ListTile(
                  leading: const Icon(Icons.work, color: Colors.green),
                  title: const Text("Designation"),
                  subtitle: Text(profile?.designation?.name.toString() ?? "--"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
