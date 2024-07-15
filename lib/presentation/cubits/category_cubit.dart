import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/remove_category.dart';
import '../../domain/usecases/update_category.dart';
import '../../domain/usecases/get_all_categories.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final AddCategory addCategoryUseCase;
  final RemoveCategory removeCategoryUseCase;
  final UpdateCategory updateCategoryUseCase;
  final GetAllCategories getAllCategoriesUseCase;

  CategoryCubit({
    required this.addCategoryUseCase,
    required this.removeCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.getAllCategoriesUseCase,
  }) : super(CategoryInitial());

  Future<void> loadCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await getAllCategoriesUseCase.call();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories'));
    }
  }

  Future<void> addCategory(String name) async {
    try {
      final category = Category(id: '', name: name, createdAt: DateTime.now());
      await addCategoryUseCase.call(category);
      loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to add category'));
    }
  }

  Future<void> removeCategory(String id) async {
    try {
      await removeCategoryUseCase.call(id);
      loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to remove category'));
    }
  }

  Future<void> updateCategory(String id, String newName) async {
    try {
      final category = Category(id: id, name: newName, createdAt: DateTime.now());
      await updateCategoryUseCase.call(category);
      loadCategories();
    } catch (e) {
      emit(CategoryError('Failed to update category'));
    }
  }
}
