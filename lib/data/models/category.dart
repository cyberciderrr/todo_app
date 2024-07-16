import 'package:uuid/uuid.dart';

class CategoryModel {
  final String id;
  final String name;
  final DateTime createdAt;

  CategoryModel({required this.name, String? id})
      : id = id ?? Uuid().v4(),
        createdAt = DateTime.now();

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };
}
