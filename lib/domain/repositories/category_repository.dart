import '../entities/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> removeCategory(String id);
  Future<void> updateCategory(Category category);
  Future<List<Category>> getAllCategories();
}
