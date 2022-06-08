part of 'categories_upload_bloc.dart';

abstract class CategoriesUploadState extends Equatable {
  const CategoriesUploadState();

  @override
  List<Object> get props => [];
}

class CategoriesUploadInitialState extends CategoriesUploadState {}

class CategoriesUploadingState extends CategoriesUploadState {}
