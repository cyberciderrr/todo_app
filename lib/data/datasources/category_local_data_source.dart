import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> removeCategory(String id);
  Future<void> updateCategory(CategoryModel category);
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final AppDatabase database;

  CategoryLocalDataSourceImpl({required this.database});

  @override
  Future<void> addCategory(CategoryModel category) async {
    await database.insertCategory(CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      createdAt: Value(category.createdAt),
    ) as Category);
  }

  @override
  Future<void> removeCategory(String id) async {
    await database.deleteCategory(id);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await database.updateCategory(CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      createdAt: Value(category.createdAt),
    ) as Category);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final categories = await database.getAllCategories();
    return categories.map((c) => CategoryModel(
      id: c.id,
      name: c.name,
      createdAt: c.createdAt,
    )).toList();
  }
}
