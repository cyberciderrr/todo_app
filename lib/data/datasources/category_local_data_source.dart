import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> removeCategory(String id);
  Future<void> updateCategory(CategoryModel category);
  Future<List<CategoryModel>> getAllCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({required this.sharedPreferences});

  static const CATEGORIES_KEY = 'CATEGORIES';

  @override
  Future<void> addCategory(CategoryModel category) async {
    final categories = await getAllCategories();
    categories.add(category);
    await sharedPreferences.setString(CATEGORIES_KEY, jsonEncode(categories));
  }

  @override
  Future<void> removeCategory(String id) async {
    final categories = await getAllCategories();
    categories.removeWhere((category) => category.id == id);
    await sharedPreferences.setString(CATEGORIES_KEY, jsonEncode(categories));
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final categories = await getAllCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await sharedPreferences.setString(CATEGORIES_KEY, jsonEncode(categories));
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final jsonString = sharedPreferences.getString(CATEGORIES_KEY);
    if (jsonString != null) {
      final List decodedJson = jsonDecode(jsonString);
      return decodedJson.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
