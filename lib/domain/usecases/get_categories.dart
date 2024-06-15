import '../entities/category.dart';
import '../repositories/category_repository.dart';
import 'usecase.dart';


class GetCategories implements UseCase<List<Category>, NoParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<List<Category>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

