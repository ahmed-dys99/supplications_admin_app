class Supplication {
  final String supplicationId;
  final String audio;
  final String arabicText;
  final String englishTranslation;
  final String romanArabic;
  final String categoryId;
  final int index;

  Supplication({
    required this.supplicationId,
    required this.audio,
    required this.arabicText,
    required this.englishTranslation,
    required this.romanArabic,
    required this.categoryId,
    required this.index,
  });
}
