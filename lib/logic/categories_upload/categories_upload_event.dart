part of 'categories_upload_bloc.dart';

abstract class CategoriesUploadEvent extends Equatable {}

class CategoriesUploadUpdateEvent extends CategoriesUploadEvent {
  final String name;
  final File? image;
  final String? categoryId;

  CategoriesUploadUpdateEvent({required this.name, this.image, this.categoryId});

  @override
  List<Object> get props => [image ?? '', categoryId ?? '', name];
}

class CategoriesUploadDeleteEvent extends CategoriesUploadEvent {
  final String categoryId;

  CategoriesUploadDeleteEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
