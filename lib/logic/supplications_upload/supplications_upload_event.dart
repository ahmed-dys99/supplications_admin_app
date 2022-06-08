part of 'supplications_upload_bloc.dart';

abstract class SupplicationsUploadEvent extends Equatable {
  const SupplicationsUploadEvent();

  @override
  List<Object> get props => [];
}

class SupplicationsUploadUpdateEvent extends SupplicationsUploadEvent {
  final String arabicText;
  final String englishTranslation;
  final String romanArabic;
  final String categoryId;
  final File? audio;
  final String? supplicationsId;

  const SupplicationsUploadUpdateEvent({
    required this.arabicText,
    required this.englishTranslation,
    required this.romanArabic,
    required this.categoryId,
    this.audio,
    this.supplicationsId,
  });

  @override
  List<Object> get props => [audio ?? '', supplicationsId ?? '', arabicText, englishTranslation, romanArabic, categoryId];
}

class SupplicationsUploadDeleteEvent extends SupplicationsUploadEvent {
  final String categoryId;
  final String supplicationId;

  const SupplicationsUploadDeleteEvent({required this.supplicationId, required this.categoryId});

  @override
  List<Object> get props => [supplicationId, categoryId];
}
