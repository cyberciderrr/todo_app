class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isFavourite;
  final DateTime createdAt;
  final String categoryId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isFavourite,
    required this.createdAt,
    required this.categoryId,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isFavourite,
    DateTime? createdAt,
    String? categoryId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavourite: isFavourite ?? this.isFavourite,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
