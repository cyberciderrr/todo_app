import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<void> saveCategories(List<Category> categories);
}
