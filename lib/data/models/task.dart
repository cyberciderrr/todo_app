import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required bool isFavourite,
    required String categoryId,
    required DateTime createdAt,
  }) : super(
    id: id,
    title: title,
    description: description,
    isCompleted: isCompleted,
    isFavourite: isFavourite,
    categoryId: categoryId,
    createdAt: createdAt,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      isFavourite: json['isFavourite'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isFavourite': isFavourite,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
