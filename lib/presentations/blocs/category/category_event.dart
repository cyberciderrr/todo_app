part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final Category category;

  const AddCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class RemoveCategoryEvent extends CategoryEvent {
  final Category category;

  const RemoveCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
