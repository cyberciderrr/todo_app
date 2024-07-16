import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  const GetAllCategories(this.repository);

  Future<List<Category>> call() {
    return repository.getAllCategories();
  }
}
