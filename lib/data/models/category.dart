import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name, super.createdAt
  }) : super(
    id: id,
    name: name,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
