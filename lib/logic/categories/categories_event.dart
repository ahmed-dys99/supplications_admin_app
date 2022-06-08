part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent extends Equatable {}

class CategoriesFetchEvent extends CategoriesEvent {
  @override
  List<Object> get props => [];
}

class CategoriesFetchSuccessEvent extends CategoriesEvent {
  final List<Category> categories;

  CategoriesFetchSuccessEvent({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesFetchFailedEvent extends CategoriesEvent {
  @override
  List<Object> get props => [];
}
