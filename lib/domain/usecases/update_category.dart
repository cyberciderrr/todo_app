import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'usecase.dart';

class UpdateCategory implements UseCase<void, Category> {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  @override
  Future<void> call(Category category) async {
    final categories = await repository.getCategories();
    final index = categories.indexWhere((item) => item.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await repository.saveCategories(categories);
    }
  }
}
