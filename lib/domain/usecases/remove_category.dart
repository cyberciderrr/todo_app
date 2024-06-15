import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'usecase.dart';

class RemoveCategory implements UseCase<void, Category> {
  final CategoryRepository repository;

  RemoveCategory(this.repository);

  @override
  Future<void> call(Category category) async {
    final categories = await repository.getCategories();
    categories.removeWhere((item) => item.id == category.id);
    await repository.saveCategories(categories);
  }
}