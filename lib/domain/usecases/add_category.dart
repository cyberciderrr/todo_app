import '../entities/category.dart';
import '../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  const AddCategory(this.repository);

  Future<void> call(Category category) {
    return repository.addCategory(category);
  }
}
