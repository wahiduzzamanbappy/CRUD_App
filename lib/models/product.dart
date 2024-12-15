class Product {
  String? id;
  String? productName;
  String? productCode;
  String? unitPrice;
  String? image;
  String? quantity;
  String? totalPrice;
  String? createdDate;

  Product({
    required this.id,
    required this.productCode,
    required this.unitPrice,
    required this.image,
    required this.quantity,
    required this.totalPrice,
    required this.createdDate,
    required this.productName,
  });

  void removeAt(index) {}
}
