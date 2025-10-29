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

    // Fetch employee profile data
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

        final profile = controller.Profiledata.value.data;

        if (profile == null) {
          return const Center(
            child: Text(
              "No Profile Data Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        // Use DefaultTabController to manage the tab state
        return DefaultTabController(
          length: 4, // Four tabs: Personal, Company, Bank, System
          child: Column(
            children: [
              // 👤 Profile Header
              _buildProfileHeader(profile),

              // 📑 Tab Bar
              // 📑 Tab Bar
              Container(
                color: Colors.white, // Background for the tab bar
                child: TabBar(
                  // isScrollable: true, // <--- ADD THIS LINE
                  textScaler: TextScaler.linear(0.9),
                  labelColor: Colors.green.shade700,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Colors.green.shade700,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(icon: Icon(Icons.person_outline), text: "Personal"),
                    Tab(icon: Icon(Icons.business_center_outlined), text: "Company"),
                    Tab(icon: Icon(Icons.account_balance_outlined), text: "Bank"),
                    Tab(icon: Icon(Icons.settings_outlined), text: "System"),
                  ],
                ),
              ),

              // 📄 Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    // 1. Personal Info Page
                    _buildInfoPage(
                      children: [
                        _infoCard(icon: Icons.badge, title: "Employee ID", value: profile.employeeId ?? "--"),
                        _infoCard(icon: Icons.calendar_today, title: "Date of Birth", value: profile.dob ?? "--"),
                        _infoCard(icon: Icons.person, title: "Gender", value: profile.gender ?? "--"),
                        _infoCard(icon: Icons.phone, title: "Phone", value: profile.phone ?? "--"),
                        _infoCard(icon: Icons.email, title: "Email", value: profile.email ?? "--"),
                        _infoCard(icon: Icons.home, title: "Address", value: profile.address ?? "--", isMultiLine: true),
                      ],
                    ),

                    // 2. Company Info Page
                    _buildInfoPage(
                      children: [
                        _infoCard(icon: Icons.apartment, title: "Branch", value: profile.branch?.name ?? "--"),
                        _infoCard(icon: Icons.account_tree, title: "Department", value: profile.department?.name ?? "--"),
                        _infoCard(icon: Icons.work, title: "Designation", value: profile.designation?.name ?? "--"),
                        _infoCard(icon: Icons.calendar_month, title: "Date of Joining", value: profile.companyDoj ?? "--"),
                        _infoCard(icon: Icons.monetization_on, title: "Salary Type", value: profile.salaryType ?? "--"),
                        _infoCard(icon: Icons.payments, title: "Salary", value: profile.salary ?? "--"),
                      ],
                    ),

                    // 3. Bank Details Page
                    _buildInfoPage(
                      children: [
                        _infoCard(icon: Icons.person_outline, title: "Account Holder", value: profile.accountHolderName ?? "--"),
                        _infoCard(icon: Icons.credit_card, title: "Account Number", value: profile.accountNumber ?? "--"),
                        _infoCard(icon: Icons.account_balance, title: "Bank Name", value: profile.bankName ?? "--"),
                        _infoCard(icon: Icons.qr_code, title: "Bank Identifier Code", value: profile.bankIdentifierCode ?? "--"),
                        _infoCard(icon: Icons.location_on, title: "Branch Location", value: profile.branchLocation ?? "--"),
                        _infoCard(icon: Icons.numbers, title: "Tax Payer ID", value: profile.taxPayerId ?? "--"),
                      ],
                    ),

                    // 4. System Info Page
                    _buildInfoPage(
                      children: [
                        _infoCard(icon: Icons.lock_outline, title: "Account Active", value: profile.isActive == true ? "Yes" : "No"),
                        _infoCard(icon: Icons.schedule, title: "Created At", value: profile.createdAt ?? "--"),
                        _infoCard(icon: Icons.update, title: "Updated At", value: profile.updatedAt ?? "--"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 👤 Reusable Profile Header
  Widget _buildProfileHeader(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.green.shade400,
            child: Text(
              (profile.name != null && profile.name!.isNotEmpty)
                  ? profile.name![0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name ?? "--",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.designation?.name ?? "--",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // 📄 Reusable Info Page (for tab content)
  Widget _buildInfoPage({required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: children,
      ),
    );
  }

  // 📇 Reusable Info Card (Redesigned)
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiLine = false, // For long values like addresses
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green.shade700, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // The label (e.g., "Email")
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value, // The value (e.g., "test@example.com")
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: isMultiLine,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}