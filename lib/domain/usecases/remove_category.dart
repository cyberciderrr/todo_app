import '../repositories/category_repository.dart';

class RemoveCategory {
  final CategoryRepository repository;

  const RemoveCategory(this.repository);

  Future<void> call(String id) {
    return repository.removeCategory(id);
  }
}
