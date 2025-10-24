import 'dart:io';
import 'package:erp_admin/module/expense/controller/expense_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart'; // <-- 1. ADD THIS IMPORT

class LogExpenseScreen extends StatefulWidget {
  const LogExpenseScreen({super.key});

  @override
  State<LogExpenseScreen> createState() => _LogExpenseScreenState();
}

class _LogExpenseScreenState extends State<LogExpenseScreen> {
  final ExpenseController expenseController = Get.find();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();
  final TextEditingController taxRateController = TextEditingController();

  int? selectedCategoryId;
  bool isTaxable = false;
  File? selectedDocument;
  String taxType = "exclusive"; // default value

  List<Item> items = [];

  double get totalExpense => items.fold(
      0,
      (sum, item) =>
          sum +
          item.subtotal +
          (item.isTaxable ? item.subtotal * item.taxRate / 100 : 0));

  @override
  void initState() {
    super.initState();
    if (expenseController.categoryList.isEmpty) {
      expenseController.fetchExpenseCategories();
    }
  }

  // --- Replace your _pickFile() with this version ---
Future<void> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
  );

  if (result != null && result.files.single.path != null) {
    final pickedFile = File(result.files.single.path!);
    final fileSizeBytes = await pickedFile.length();
    final fileSizeMB = fileSizeBytes / (1024 * 1024);

    // Check file size limit (5 MB)
    if (fileSizeMB > 5) {
      Get.snackbar(
        "File Too Large",
        "Please select a file smaller than 5 MB.",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red.shade900,
      );
      return;
    }

    setState(() {
      selectedDocument = pickedFile;
    });
  }
}


  void _addItem() {
    if (itemNameController.text.isEmpty || subtotalController.text.isEmpty) {
      Get.snackbar("Error", "Enter item name and subtotal",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade900);
      return;
    }

    if (isTaxable && taxRateController.text.isEmpty) {
      Get.snackbar("Error", "Enter tax rate for taxable item",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade900);
      return;
    }

    double subtotal = double.tryParse(subtotalController.text) ?? 0;
    double taxRate = double.tryParse(taxRateController.text) ?? 0;

    setState(() {
      items.add(Item(
        itemName: itemNameController.text,
        subtotal: subtotal,
        isTaxable: isTaxable,
        taxRate: taxRate,
        document: selectedDocument, // optional for all
        taxType: taxType,
      ));

      // Reset input fields
      itemNameController.clear();
      subtotalController.clear();
      taxRateController.clear();
      isTaxable = false;
      selectedDocument = null;
      taxType = "exclusive";
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // --- 2. ADD THIS HELPER FUNCTION ---
  Future<void> _openSelectedFile(File? file) async {
    if (file == null) {
      Get.snackbar("No File", "There is no file to open.",
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange.shade900);
      return;
    }
    if (await file.exists()) {
      await OpenFilex.open(file.path);
    } else {
      Get.snackbar("Error", "File not found.",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade900);
    }
  }
  // ------------------------------------

  Future<void> _submitExpense() async {
    if (descriptionController.text.isEmpty || selectedCategoryId == null) {
      Get.snackbar("Error", "Please enter description and select category",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade900);
      return;
    }

    if (items.isEmpty) {
      Get.snackbar("Error", "Please add at least one item",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red.shade900);
      return;
    }

    List<Map<String, dynamic>> itemsData = [];
    Map<String, MultipartFile> fileMap = {};

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      Map<String, dynamic> map = {
        "item_name": item.itemName,
        "subtotal": item.subtotal,
        "is_taxable": item.isTaxable,
      };

      if (item.isTaxable) {
        map["tax_rate"] = item.taxRate;
        map["tax_type"] = item.taxType;
      }

      if (item.document != null) {
        final mimeType =
            lookupMimeType(item.document!.path) ?? 'application/octet-stream';

        fileMap["item_document_$i"] = MultipartFile(
          item.document!,
          filename: item.document!.path.split('/').last,
          contentType: mimeType,
        );
      }

      itemsData.add(map);
    }

    await expenseController.createExpense(
      categoryId: selectedCategoryId!,
      description: descriptionController.text,
      items: itemsData,
      files: fileMap,
    );

    if (expenseController.expenseResponse.value?.success == true) {
      Get.snackbar("Success", "Expense logged successfully ✅",
          backgroundColor: Colors.green.withOpacity(0.2),
          colorText: Colors.green.shade800);
      Navigator.pop(context, true);
    }
  }

  InputDecoration _buildInputDecoration(
      {required String labelText, required IconData icon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.green.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.green.shade200, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildDocumentPreview(File? document) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: () {
              if (document == null) {
                return const Icon(Icons.insert_drive_file_outlined,
                    color: Colors.grey);
              }
              if (document.path.endsWith(".pdf")) {
                return const Icon(Icons.picture_as_pdf,
                    color: Colors.red, size: 30);
              }
              return Image.file(
                document,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              );
            }(),
          ),
        ),
      ),
      const SizedBox(height: 4),
      // --- File size text (only if file selected)
      if (document != null)
        Text(
          _getReadableFileSize(document),
          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
    ],
  );
}


  String _getReadableFileSize(File file) {
  final bytes = file.lengthSync();
  final mb = bytes / (1024 * 1024);
  return "${mb.toStringAsFixed(2)} MB / 5 MB";
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Expense"),
        backgroundColor: Colors.green,
        elevation: 0,
        foregroundColor: Colors.white, // Ensures back button is white
      ),
      body: Obx(() {
        if (expenseController.isFetchingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = expenseController.categoryList;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              TextField(
                controller: descriptionController,
                decoration: _buildInputDecoration(
                  labelText: "Description / Reason",
                  icon: Icons.description,
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                items: categories
                    .map((cat) => DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text(cat.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value!;
                  });
                },
                decoration: _buildInputDecoration(
                  labelText: "Select Category",
                  icon: Icons.category,
                ),
              ),
              const SizedBox(height: 24),

              // --- BEAUTIFIED: Item input card ---
              Card(
                elevation: 2,
                shadowColor: Colors.green.withOpacity(0.2),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Title
                      Text(
                        "Add New Item",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Item Name
                      TextField(
                        controller: itemNameController,
                        decoration: _buildInputDecoration(
                          labelText: "Item Name",
                          icon: Icons.shopping_bag_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtotal
                      TextField(
                        controller: subtotalController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          labelText: "Subtotal",
                          icon: Icons.currency_rupee,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Taxable Switch
                      SwitchListTile(
                        title: const Text("Is this item taxable?"),
                        value: isTaxable,
                        activeColor: Colors.green,
                        onChanged: (val) => setState(() => isTaxable = val),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),

                      // Taxable Fields
                      if (isTaxable) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: taxRateController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            labelText: "Tax Rate (%)",
                            icon: Icons.percent,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: taxType,
                          items: const [
                            DropdownMenuItem(
                                value: "exclusive",
                                child: Text("Exclusive Tax")),
                            DropdownMenuItem(
                                value: "inclusive",
                                child: Text("Inclusive Tax")),
                          ],
                          onChanged: (val) => setState(() => taxType = val!),
                          decoration: _buildInputDecoration(
                            labelText: "Tax Type",
                            icon: Icons.money,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // --- 3. MAKE THIS PREVIEW CLICKABLE ---
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. The preview (now clickable)
                          InkWell(
                            onTap: () => _openSelectedFile(selectedDocument),
                            borderRadius: BorderRadius.circular(8),
                            child: _buildDocumentPreview(selectedDocument),
                          ),
                          const SizedBox(width: 12),

                          // 2. The button, expanded to fill space
                          Expanded(
                            child: TextButton.icon(
                              onPressed: _pickFile,
                              icon: const Icon(Icons.attach_file),
                              label: Text(
                                selectedDocument == null
                                    ? "Attach Document (Optional)"
                                    : "Attached: ${selectedDocument!.path.split('/').last}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green.shade800,
                                backgroundColor: Colors.green.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // --- END MODIFICATION ---

                      const SizedBox(height: 12),

                      // Add Item Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // -----------------------------------
              const SizedBox(height: 24),

              // --- MODIFIED: Items preview list ---
              if (items.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Added Items",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          elevation: 1,
                          shadowColor: Colors.green.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            // --- 3. MAKE THIS PREVIEW CLICKABLE ---
                            leading: InkWell(
                              onTap: () => _openSelectedFile(item.document),
                              borderRadius: BorderRadius.circular(8),
                              child: _buildDocumentPreview(item.document),
                            ),
                            title: Text(
                              item.itemName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Subtotal: ₹${item.subtotal.toStringAsFixed(2)}"),
                                if (item.isTaxable)
                                  Text(
                                    "Tax: ${item.taxRate}% (${item.taxType})",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: Colors.red.shade700),
                              onPressed: () => _deleteItem(index),
                            ),
                            isThreeLine: item.isTaxable,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              // -----------------------------------
              const SizedBox(height: 24),

              // Total Expense
              if (items.isNotEmpty)
                Text(
                  "Total: ₹${totalExpense.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                ),

              const SizedBox(height: 24),

              // Submit Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          expenseController.isLoading.value ? null : _submitExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: expenseController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("Save Expense"),
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }
}

class Item {
  String itemName;
  double subtotal;
  bool isTaxable;
  double taxRate;
  String taxType; // inclusive or exclusive
  File? document; // optional for all

  Item({
    required this.itemName,
    required this.subtotal,
    this.isTaxable = false,
    this.taxRate = 0,
    this.taxType = "exclusive",
    this.document,
  });
}