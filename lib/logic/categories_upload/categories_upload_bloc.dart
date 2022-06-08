import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supplications_admin_app/data/repos/supplicationsRepo.dart';

part 'categories_upload_event.dart';
part 'categories_upload_state.dart';

class CategoriesUploadBloc extends Bloc<CategoriesUploadEvent, CategoriesUploadState> {
  final SupplicationsRepo _supplicationsRepo;

  CategoriesUploadBloc({required SupplicationsRepo supplicationsRepo})
      : _supplicationsRepo = supplicationsRepo,
        super(CategoriesUploadInitialState()) {
    on<CategoriesUploadUpdateEvent>((event, emit) async {
      emit(CategoriesUploadingState());
      await _supplicationsRepo.uploadCategory(name: event.name, image: event.image, categoryId: event.categoryId);
      emit(CategoriesUploadInitialState());
    });
    on<CategoriesUploadDeleteEvent>((event, emit) async {
      await _supplicationsRepo.deleteCategory(categoryId: event.categoryId);
      Fluttertoast.showToast(msg: 'Category deleted', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
    });
  }
}
