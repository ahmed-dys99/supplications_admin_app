part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {}

class CategoriesInitialState extends CategoriesState {
  @override
  List<Object> get props => [];
}

class CategoriesFetchedState extends CategoriesState {
  final List<Category> categories;

  CategoriesFetchedState({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesErrorState extends CategoriesState {
  @override
  List<Object> get props => [];
}
