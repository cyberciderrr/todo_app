import '../../data/models/category.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'usecase.dart';

class SaveCategory implements UseCase<void, SaveCategoryParams> {
  final CategoryRepository repository;

  SaveCategory(this.repository);

  @override
  Future<void> call(SaveCategoryParams params) async {
    final categories = await repository.getCategories();
    final index = categories.indexWhere((c) => c.id == params.category.id);
    if (index != -1) {
      categories[index] = params.category;
    } else {
      categories.add(params.category);
    }
    await repository.saveCategories(categories);
  }
}

class SaveCategoryParams {
  final CategoryModel category;

  SaveCategoryParams({
    required this.category,
  });
}
