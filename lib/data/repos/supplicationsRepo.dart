import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supplications_admin_app/data/models/category.dart';
import 'package:supplications_admin_app/data/models/supplication.dart';
import 'package:path/path.dart' as path;

class SupplicationsRepo {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _firebaseAuth;

  SupplicationsRepo()
      : _firestore = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance,
        _firebaseAuth = FirebaseAuth.instance;

  final Map<String, Category> _categories = {};
  final Map<String, Map<String, Supplication>> _supplications = {};

  final _categoryController = StreamController<List<Category>>();
  Stream<List<Category>> get categoryStream => _categoryController.stream;

  final _supplicationsController = StreamController<List<Supplication>>();
  Stream<List<Supplication>> get supplicationsStream => _supplicationsController.stream;

  Future<void> login() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
  }

  Future<void> fetchCategories() async {
    final _snapshot = await _firestore.collection("categories").get();

    for (var element in _snapshot.docs) {
      final id = element.id;
      final data = element.data();

      _categories[id] = Category(categoryId: id, name: data['name'], image: data['image'], index: data['index'] ?? _snapshot.docs.length);
    }

    _categoryController.sink.add(_categories.values.toList());
  }

  Future<void> uploadCategory({required String name, File? image, String? categoryId}) async {
    await login();

    String? fileUrl;
    Category? category;

    final docRef = (categoryId == null) ? _firestore.collection('categories').doc() : _firestore.collection('categories').doc(categoryId);

    if (image != null) {
      final storageRef = _storage.ref().child('images').child(docRef.id + path.basename(image.path));
      await storageRef.putFile(image);

      fileUrl = await storageRef.getDownloadURL();
    }

    if (categoryId != null) {
      category = _categories[categoryId];
    }

    await docRef.set({
      'name': name,
      'image': (fileUrl == null) ? category!.image : fileUrl,
    });

    _categories[docRef.id] = Category(
      categoryId: docRef.id,
      name: name,
      image: (fileUrl == null) ? category!.image : fileUrl,
      index: _categories.length,
    );

    _categoryController.sink.add(_categories.values.toList());
  }

  Future<void> deleteCategory({required String categoryId}) async {
    await _firestore.collection('categories').doc(categoryId).delete();

    _categories.remove(categoryId);

    _categoryController.sink.add(_categories.values.toList());
  }

  Future<void> fetchSupplications(String categoryId) async {
    if (!_supplications.containsKey(categoryId)) {
      _supplications[categoryId] = {};

      final _snapshot = await _firestore.collection("supplications").where("categoryId", isEqualTo: categoryId).get();

      for (var element in _snapshot.docs) {
        final id = element.id;
        final data = element.data();

        _supplications[categoryId]![id] = Supplication(
          supplicationId: id,
          audio: data['audio'],
          arabicText: data['arabicText'],
          englishTranslation: data['englishTranslation'],
          romanArabic: data['romanArabic'],
          categoryId: data['categoryId'],
          index: data['index'] ?? 0,
        );
      }
    }

    _supplicationsController.sink.add(_supplications[categoryId]!.values.toList());
  }

  Future<void> uploadSupplications(
      {required String arabicText, required String englishTranslation, required String romanArabic, required String categoryId, File? audio, String? supplicationsId}) async {
    await login();

    String? fileUrl;
    Supplication? supplication;

    final docRef = (supplicationsId == null) ? _firestore.collection('supplications').doc() : _firestore.collection('supplications').doc(supplicationsId);

    if (audio != null) {
      final storageRef = _storage.ref().child('audios').child(categoryId + docRef.id + path.basename(audio.path));
      await storageRef.putFile(audio);

      fileUrl = await storageRef.getDownloadURL();
    }

    if (supplicationsId != null) {
      supplication = _supplications[categoryId]![supplicationsId];
    }

    await docRef.set({
      'arabicText': arabicText,
      'audio': (fileUrl != null) ? fileUrl : _supplications[categoryId]![docRef.id]!.audio,
      'categoryId': categoryId,
      'englishTranslation': englishTranslation,
      'romanArabic': romanArabic,
    });

    _supplications[categoryId]![docRef.id] = Supplication(
      supplicationId: docRef.id,
      audio: (audio == null) ? supplication!.audio : fileUrl!,
      arabicText: arabicText,
      englishTranslation: englishTranslation,
      romanArabic: romanArabic,
      categoryId: categoryId,
      index: _supplications[categoryId]!.length,
    );

    _supplicationsController.sink.add(_supplications[categoryId]!.values.toList());
  }

  Future<void> deleteSupplication({required String categoryId, required String supplicationId}) async {
    await _firestore.collection('supplications').doc(supplicationId).delete();

    _supplications[categoryId]!.remove(supplicationId);

    _supplicationsController.sink.add(_supplications[categoryId]!.values.toList());
  }
}
