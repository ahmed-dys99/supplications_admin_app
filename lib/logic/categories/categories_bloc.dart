import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:supplications_admin_app/data/models/category.dart';
import 'package:supplications_admin_app/data/repos/supplicationsRepo.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final SupplicationsRepo _supplicationsRepo;
  StreamSubscription? subscription;

  CategoriesBloc({required SupplicationsRepo supplicationsRepo})
      : _supplicationsRepo = supplicationsRepo,
        super(CategoriesInitialState()) {
    on<CategoriesFetchEvent>((event, emit) async {
      subscription ??= _supplicationsRepo.categoryStream.listen((List<Category> categories) {
        add(CategoriesFetchSuccessEvent(categories: categories));
      });

      _supplicationsRepo.fetchCategories();
    });
    on<CategoriesFetchSuccessEvent>((event, emit) {
      emit(CategoriesInitialState());
      emit(CategoriesFetchedState(categories: event.categories));
    });
    on<CategoriesFetchFailedEvent>((event, emit) {});
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
