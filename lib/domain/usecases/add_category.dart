import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'usecase.dart';

class AddCategory implements UseCase<void, Category> {
  final CategoryRepository repository;

  AddCategory(this.repository);

  @override
  Future<void> call(Category category) async {
    final categories = await repository.getCategories();
    categories.add(category);
    await repository.saveCategories(categories);
  }
}