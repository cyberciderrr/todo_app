import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/category.dart';
import '../../core/exceptions.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> saveCategories(List<CategoryModel> categories);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final String? categoriesJson = sharedPreferences.getString('categories');
      if (categoriesJson != null) {
        final List<dynamic> categoriesList = jsonDecode(categoriesJson);
        return categoriesList.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    try {
      final String categoriesJson = jsonEncode(categories.map((category) => category.toJson()).toList());
      await sharedPreferences.setString('categories', categoriesJson);
    } catch (e) {
      throw CacheException();
    }
  }

}
