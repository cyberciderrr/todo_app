import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/category.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/save_categories.dart';
import '../../../domain/usecases/add_category.dart';
import '../../../domain/usecases/remove_category.dart';
import '../../../domain/usecases/update_category.dart';
import '../../../domain/usecases/usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategoriesUseCase;
  final SaveCategory saveCategoryUseCase;
  final AddCategory addCategoryUseCase;
  final RemoveCategory removeCategoryUseCase;
  final UpdateCategory updateCategoryUseCase;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.saveCategoryUseCase,
    required this.addCategoryUseCase,
    required this.removeCategoryUseCase,
    required this.updateCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<RemoveCategoryEvent>(_onRemoveCategory);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());
      final categories = await getCategoriesUseCase(NoParams());
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      if (state is CategoryLoaded) {
        final updatedCategories = List<Category>.from((state as CategoryLoaded).categories)..add(event.category);
        final categoryModel = CategoryModel(
          id: event.category.id,
          name: event.category.name,
          createdAt: event.category.createdAt,
        );
        await saveCategoryUseCase(SaveCategoryParams(category: categoryModel));
        emit(CategoryLoaded(updatedCategories));
      }
    } catch (e) {
      emit(CategoryError('Failed to add category: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      if (state is CategoryLoaded) {
        final updatedCategories = (state as CategoryLoaded).categories.map((category) {
          return category.id == event.category.id ? event.category : category;
        }).toList();
        final categoryModel = CategoryModel(
          id: event.category.id,
          name: event.category.name,
          createdAt: event.category.createdAt,
        );
        await saveCategoryUseCase(SaveCategoryParams(category: categoryModel));
        emit(CategoryLoaded(updatedCategories));
      }
    } catch (e) {
      emit(CategoryError('Failed to update category: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveCategory(RemoveCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      if (state is CategoryLoaded) {
        final updatedCategories = (state as CategoryLoaded).categories.where((category) => category.id != event.category.id).toList();
        final categoryModel = CategoryModel(
          id: event.category.id,
          name: event.category.name,
          createdAt: event.category.createdAt,
        );
        await saveCategoryUseCase(SaveCategoryParams(category: categoryModel));
        emit(CategoryLoaded(updatedCategories));
      }
    } catch (e) {
      emit(CategoryError('Failed to remove category: ${e.toString()}'));
    }
  }
}
