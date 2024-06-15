class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name, required createdAt,
  });

  get createdAt => null;

  Category copyWith({
    String? id,
    String? name,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name, createdAt: null,
    );
  }
}
