import 'dart:io';

class Item {
  String itemName;
  double subtotal;
  bool isTaxable;
  double taxRate;
  String taxType;
  File? document;
  String? mimeType;

  Item({
    required this.itemName,
    required this.subtotal,
    this.isTaxable = false,
    this.taxRate = 0,
    this.taxType = "exclusive",
    this.document,
    this.mimeType,
  });
}
