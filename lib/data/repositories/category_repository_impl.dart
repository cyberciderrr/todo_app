import '../../core/exceptions.dart';
import '../models/category.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart' as data_source;

class CategoryRepositoryImpl implements CategoryRepository {
  final data_source.CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await localDataSource.getCategories();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveCategories(List<Category> categories) async {
    try {
      final List<CategoryModel> categoryModels = categories.map((category) => CategoryModel(
        id: category.id,
        name: category.name,
        createdAt: category.createdAt,
      )).toList();
      await localDataSource.saveCategories(categoryModels);
    } catch (e) {
      throw CacheException();
    }
  }
}
