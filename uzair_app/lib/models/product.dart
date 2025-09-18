class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? discountPercentage;
  final String? image;
  final bool status;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.discountPercentage,
    this.image,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json, {String category = ""}) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: category,
      price: (json['price'] ?? 0.0).toDouble(),
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] as num).toDouble()
          : null,
      image: json['image'],
      status: json['status'] ?? true,
    );
  }
}