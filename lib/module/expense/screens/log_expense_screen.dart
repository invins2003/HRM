import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:erp_admin/module/expense/controller/expense_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dotted_border/dotted_border.dart';

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

  // --- NEW: State variables for new fields ---
  final TextEditingController _vendorNameController = TextEditingController();
  String _purchaseType = "cash"; // 'cash' or 'credit'
  String? _creditPurchaseType; // 'service' or 'supply'
  // ------------------------------------------

  int? selectedCategoryId;
  bool isTaxable = false;
  // File? selectedDocument; //filess
  String taxType = "exclusive"; // default value

  List<Item> items = [];

  double get totalExpense => items.fold(
    0,
    (sum, item) =>
        sum +
        item.subtotal +
        (item.isTaxable ? item.subtotal * item.taxRate / 100 : 0),
  );

  @override
  void initState() {
    super.initState();
    if (expenseController.categoryList.isEmpty) {
      expenseController.fetchExpenseCategories();
    }
  }
  //Botoom Sheet   ---->>>> ........................................

    File? selectedDocument; //filess
    bool isPDF = false;
    ImageProvider? displayImage;

    final ImagePicker _picer = ImagePicker();

    void _openBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          File? tempDocument = selectedDocument; // temporary variable

          return StatefulBuilder(
            builder: (context, setStateSheet) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Pick File", style: TextStyle(fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Updated Dotted Border
                    // Updated Dotted Border
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: BorderType.Radius.circular(10), // Your radius
                  dashPattern: const [6, 3],
                  color: Colors.grey,
                  strokeWidth: 2,
                ),
                child: ClipRRect( // <-- ADD THIS WIDGET
                  borderRadius: BorderRadius.circular(10), // <-- MATCH THE RADIUS
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: tempDocument == null
                        ? const Text("No Preview Available")
                        : Stack(
                            children: [
                              Center(
                                child: tempDocument!.path.endsWith(".pdf")
                                    ? const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 50,
                                      )
                                    : Image.file(
                                        tempDocument!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200, // Ensure image fills the container height too
                                      ),
                              ),
                              // close button inside dotted border
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    setStateSheet(() {
                                      tempDocument = null;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ), // <-- END ClipRRect
              ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final XFile? image = await _picer.pickImage(
                                source: ImageSource.camera,
                              );
                              if (image != null) {
                                setStateSheet(() {
                                  tempDocument = File(image.path);
                                });
                              }
                            },
                            child: const Text("Pick Image"),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform
                                  .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'pdf',
                                      'jpg',
                                      'jpeg',
                                      'png',
                                    ],
                                  );
                              if (result != null &&
                                  result.files.single.path != null) {
                                setStateSheet(() {
                                  tempDocument = File(result.files.single.path!);
                                });
                              }
                            },
                            child: const Text("Pick Document"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: tempDocument == null
                                ? null
                                : () {
                                    setState(() {
                                      selectedDocument =
                                          tempDocument; // ✅ Save selected file permanently
                                    });
                                    Navigator.pop(context); // Close bottom sheet
                          
                                    // Get.snackbar(
                                    //   "Success",
                                    //   "File selected successfully ✅",
                                    //   backgroundColor: Colors.green,
                                    //   colorText: Colors.white,
                                    //   snackPosition: SnackPosition.BOTTOM,
                                    // );
                                  },
                            child: const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

  // --- Dispose controllers ---
  @override
  void dispose() {
    descriptionController.dispose();
    itemNameController.dispose();
    subtotalController.dispose();
    taxRateController.dispose();
    _vendorNameController.dispose();
    super.dispose();
  }

  // --- File picker with size validation ---
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
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        "Error",
        "Enter item name and subtotal",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isTaxable && taxRateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter tax rate for taxable item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    double subtotal = double.tryParse(subtotalController.text) ?? 0;
    double taxRate = double.tryParse(taxRateController.text) ?? 0;

    setState(() {
      items.add(
        Item(
          itemName: itemNameController.text,
          subtotal: subtotal,
          isTaxable: isTaxable,
          taxRate: taxRate,
          document: selectedDocument,
          taxType: taxType,
        ),
      );

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

  Future<void> _openSelectedFile(File? file) async {
    if (file == null) {
      Get.snackbar(
        "No File",
        "There is no file to open.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (await file.exists()) {
      await OpenFilex.open(file.path);
    } else {
      Get.snackbar(
        "Error",
        "File not found.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _submitExpense() async {
    if (descriptionController.text.isEmpty || selectedCategoryId == null) {
      Get.snackbar(
        "Error",
        "Please enter description and select category",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_purchaseType == "credit" &&
        (_vendorNameController.text.isEmpty || _creditPurchaseType == null)) {
      Get.snackbar(
        "Error",
        "For credit purchase, please enter Vendor Name and Type of Purchase",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (items.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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
      purchaseType: _purchaseType,
      vendorName: _purchaseType == "credit" ? _vendorNameController.text : null,
      creditPurchaseType: _purchaseType == "credit"
          ? _creditPurchaseType
          : null,
    );

    if (expenseController.expenseResponse.value?.success == true) {
      Get.snackbar(
        "Success",
        "Expense logged successfully ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Navigator.pop(context, true);
    }
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
  }) {
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
        Flexible(
          child: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: () {
                  if (document == null) {
                    return const Icon(
                      Icons.insert_drive_file_outlined,
                      color: Colors.grey,
                    );
                  }
                  if (document.path.endsWith(".pdf")) {
                    return const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 30,
                    );
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
        ),
        const SizedBox(height: 4),
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
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          if (expenseController.isFetchingCategories.value) {
            return const Center(child: CircularProgressIndicator());
          }
        
          final categories = expenseController.categoryList;
        
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _purchaseType,
                  items: const [
                    DropdownMenuItem(value: "cash", child: Text("Cash Purchase")),
                    DropdownMenuItem(
                      value: "credit",
                      child: Text("Credit Purchase"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _purchaseType = value!;
                    });
                  },
                  decoration: _buildInputDecoration(
                    labelText: "Purchase Type",
                    icon: Icons.storefront,
                  ),
                ),
                const SizedBox(height: 16),
        
                if (_purchaseType == "credit") ...[
                  TextField(
                    controller: _vendorNameController,
                    decoration: _buildInputDecoration(
                      labelText: "Vendor Name",
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _creditPurchaseType,
                    hint: const Text("Select Purchase Type"),
                    items: const [
                      DropdownMenuItem(value: "service", child: Text("Service")),
                      DropdownMenuItem(value: "supply", child: Text("Supply")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _creditPurchaseType = value;
                      });
                    },
                    decoration: _buildInputDecoration(
                      labelText: "Type of Purchase",
                      icon: Icons.work_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
        
                TextField(
                  controller: descriptionController,
                  decoration: _buildInputDecoration(
                    labelText: "Description / Reason",
                    icon: Icons.description,
                  ),
                ),
                const SizedBox(height: 16),
        
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text(cat.name),
                        ),
                      )
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
        
                // Item Card
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
                        Text(
                          "Add New Item",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: itemNameController,
                          decoration: _buildInputDecoration(
                            labelText: "Item Name",
                            icon: Icons.shopping_bag_outlined,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: subtotalController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration(
                            labelText: "Subtotal",
                            icon: Icons.currency_rupee,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text("Is this item taxable?"),
                          value: isTaxable,
                          activeColor: Colors.green,
                          onChanged: (val) => setState(() => isTaxable = val),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
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
                                child: Text("Exclusive Tax"),
                              ),
                              DropdownMenuItem(
                                value: "inclusive",
                                child: Text("Inclusive Tax"),
                              ),
                            ],
                            onChanged: (val) => setState(() => taxType = val!),
                            decoration: _buildInputDecoration(
                              labelText: "Tax Type",
                              icon: Icons.money,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _openSelectedFile(selectedDocument),
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildDocumentPreview(selectedDocument),
                                ),
                                if (selectedDocument != null)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDocument = null;
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: _openBottomSheet,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                const SizedBox(height: 24),
        
                // Added items list
                if (items.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Added Items",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            elevation: 8,
                            shadowColor: Colors.green.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: InkWell(
                                onTap: () => _openSelectedFile(item.document),
                                borderRadius: BorderRadius.circular(8),
                                child: _buildDocumentPreview(item.document),
                              ),
                              title: Text(
                                item.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Subtotal: ₹${item.subtotal.toStringAsFixed(2)}",
                                  ),
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
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade700,
                                ),
                                onPressed: () => _deleteItem(index),
                              ),
                              isThreeLine: item.isTaxable,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
        
                if (items.isNotEmpty)
                  Text(
                    "Total: ₹${totalExpense.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                const SizedBox(height: 24),
        
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: expenseController.isLoading.value
                          ? null
                          : _submitExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: expenseController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Save Expense"),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class Item {
  String itemName;
  double subtotal;
  bool isTaxable;
  double taxRate;
  String taxType;
  File? document;

  Item({
    required this.itemName,
    required this.subtotal,
    this.isTaxable = false,
    this.taxRate = 0,
    this.taxType = "exclusive",
    this.document,
  });
}
