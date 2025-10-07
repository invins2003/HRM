import 'package:erp_admin/common/faceattendence.dart';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/RegisterEmployee/controller/register_employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class RegisterEmployeeScreen extends StatefulWidget {
  final Data employee;

  const RegisterEmployeeScreen({super.key, required this.employee});

  @override
  State<RegisterEmployeeScreen> createState() => _RegisterEmployeeScreenState();
}

class _RegisterEmployeeScreenState extends State<RegisterEmployeeScreen> {
  List<List<double>>? capturedEmbeddings;
  List<CameraDescription>? cameras;
  late RegisterEmployeeController controller;

  @override
  void initState() {
    super.initState();
    _initCameras();
    controller = Get.put(RegisterEmployeeController());
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  Future<void> _startFaceRegistration() async {
    if (cameras == null || cameras!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No cameras found"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedCamera = cameras!.first;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceProcessingScreen(
          camera: selectedCamera,
          maxCaptures: 3,
        ),
      ),
    );

    if (result != null && mounted) {
      capturedEmbeddings = result as List<List<double>>;

      await controller.registerBiometric(
          widget.employee.employeeId!, capturedEmbeddings!);

      if (controller.success.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Biometric registered successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMsg.value),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {});
    }
  }

  Widget _employeeDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Register Employee",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Employee Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Employee Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(thickness: 1, height: 20),
                    _employeeDetailRow("Name", emp.name),
                    _employeeDetailRow("Employee ID", emp.employeeId),
                    _employeeDetailRow("Email", emp.email),
                    _employeeDetailRow("Phone", emp.phone),
                    _employeeDetailRow("Branch", emp.branch?.name),
                    _employeeDetailRow(
                        "Biometric Registered",
                        (emp.biometricEmpId != null &&
                                emp.biometricEmpId!.isNotEmpty)
                            ? "Yes"
                            : "No"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Face Capture Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Face Registration",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _startFaceRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text(
                        "Capture Face",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (capturedEmbeddings != null)
                      Text(
                        "Captured ${capturedEmbeddings!.length} samples ✅",
                        style: const TextStyle(
                            color: Colors.green, fontSize: 16),
                      )
                    else
                      const Text(
                        "No face data captured yet",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
