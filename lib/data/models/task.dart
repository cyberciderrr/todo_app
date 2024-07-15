import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isFavourite;
  final DateTime createdAt;
  final String categoryId;

  TaskModel({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isFavourite = false,
    required this.categoryId,
    String? id,
    DateTime? createdAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  TaskModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        isCompleted = json['isCompleted'],
        isFavourite = json['isFavourite'],
        createdAt = DateTime.parse(json['createdAt']),
        categoryId = json['categoryId'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'isFavourite': isFavourite,
    'createdAt': createdAt.toIso8601String(),
    'categoryId': categoryId,
  };
}
