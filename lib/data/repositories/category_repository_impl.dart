import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addCategory(Category category) {
    return localDataSource.addCategory(CategoryModel(name: category.name, id: category.id, createdAt: category.createdAt));
  }

  @override
  Future<void> removeCategory(String id) {
    return localDataSource.removeCategory(id);
  }

  @override
  Future<void> updateCategory(Category category) {
    return localDataSource.updateCategory(CategoryModel(name: category.name, id: category.id, createdAt: category.createdAt));
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final categoryModels = await localDataSource.getAllCategories();
    return categoryModels.map((model) => Category(id: model.id, name: model.name, createdAt: model.createdAt)).toList();
  }
}
