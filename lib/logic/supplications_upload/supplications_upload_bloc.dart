import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supplications_admin_app/data/repos/supplicationsRepo.dart';

part 'supplications_upload_event.dart';
part 'supplications_upload_state.dart';

class SupplicationsUploadBloc extends Bloc<SupplicationsUploadEvent, SupplicationsUploadState> {
  final SupplicationsRepo _supplicationsRepo;

  SupplicationsUploadBloc({required SupplicationsRepo supplicationsRepo})
      : _supplicationsRepo = supplicationsRepo,
        super(SupplicationsUploadInitialState()) {
    on<SupplicationsUploadUpdateEvent>((event, emit) async {
      emit(SupplicationsUploadingState());

      await _supplicationsRepo.uploadSupplications(
        arabicText: event.arabicText,
        englishTranslation: event.englishTranslation,
        romanArabic: event.romanArabic,
        categoryId: event.categoryId,
        supplicationsId: event.supplicationsId,
        audio: event.audio,
      );

      emit(SupplicationsUploadInitialState());
    });
    on<SupplicationsUploadDeleteEvent>((event, emit) async {
      await _supplicationsRepo.deleteSupplication(supplicationId: event.supplicationId, categoryId: event.categoryId);
      Fluttertoast.showToast(msg: 'Supplication deleted', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
    });
  }
}
