import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erp_admin/module/profile/controller/profile_controller.dart';
import 'package:erp_admin/utils/Constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    controller.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text("Could not load profile data."));
        }

        // Using a Stack to place the back button over the scrollable content
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, profile),
                  const SizedBox(height: 10),
                  _buildUserInfo(profile),
                  _buildInfoCard(
                    title: "Account Information",
                    children: [
                      _buildInfoTile(
                          Icons.shield_outlined, "Role", profile.type),
                      _buildInfoTile(Icons.toggle_on_outlined, "Status",
                          profile.isActive == 1 ? "Active" : "Inactive"),
                      _buildInfoTile(
                          Icons.person_add_alt_1_outlined,
                          "Created By",
                          profile.createdBy?.toString() ?? '-'),
                    ],
                  ),
                  _buildInfoCard(
                    title: "Preferences",
                    children: [
                      _buildInfoTile(Icons.display_settings_outlined, "Mode",
                          profile.mode),
                      _buildInfoTile(Icons.dark_mode_outlined, "Dark Mode",
                          profile.darkMode == true ? "Enabled" : "Disabled"),
                      _buildInfoTile(Icons.color_lens_outlined,
                          "Messenger Color", profile.messengerColor),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, profile) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // The background container with original colors
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        // Positioned avatar to make it overlap
        Positioned(
          top: 140, // (Header Height) - (Avatar Radius)
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  NetworkImage("${Constants.BASEURL}/${profile.avatar ?? ''}"),
              onBackgroundImageError: (_, __) {},
              child: profile.avatar == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(profile) {
    return Container(
      padding: const EdgeInsets.only(top: 70), // Space for the avatar
      child: Column(
        children: [
          Text(
            profile.name ?? "No Name",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email ?? "No Email",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value ?? "-",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.snackbar("Log Out", "Logout functionality coming soon!",
              snackPosition: SnackPosition.BOTTOM);
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text("Log Out", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}