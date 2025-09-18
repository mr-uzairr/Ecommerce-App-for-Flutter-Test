class Category {
  final int id;
  final String name;
  final List<dynamic> subCategory;

  Category({
    required this.id,
    required this.name,
    required this.subCategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      subCategory: json['subCategory'] ?? [],
    );
  }
}