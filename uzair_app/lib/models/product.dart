class Product {
  final int id;
  final String name;
  final double price;
  final double? discountPercentage;
  final String? image;
  final bool status;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPercentage,
    this.image,
    required this.status,
  });

 }