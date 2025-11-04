class Category {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['category'] ?? '',
      thumbnailUrl: json['categoryThumb'] ?? 'https://www.themealdb.com/images/category/beef.png',
      description: json['categoryDescription'] ?? '',
    );
  }
}