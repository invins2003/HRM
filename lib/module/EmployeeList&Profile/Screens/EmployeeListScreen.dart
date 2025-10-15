
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/EmployeeListController/EmployeeListController.dart';
import 'EmployeeLIstWidget.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeListController controller = Get.put(
    EmployeeListController(employeeListRepo: Get.find()),
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

          /// Search + Filter Row
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.search, color: Colors.black54),
                        ),
                        const SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: VerticalDivider(
                            width: 5,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(width: 5),

                        /// TextField for search
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              controller.filterEmployees(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Employee",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Filter tapped");
                    },
                    child: const Icon(Icons.filter_list, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredList.isEmpty) {
                return const Center(child: Text("No Employees Found"));
              }
              return ListWidget(employeelist: controller.filteredList);
            }),
          ),
        ],
      ),
    );
  }
}
