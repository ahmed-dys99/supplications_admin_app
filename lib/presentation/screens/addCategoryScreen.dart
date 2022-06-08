import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplications_admin_app/logic/categories/categories_bloc.dart';
import 'package:supplications_admin_app/logic/categories_upload/categories_upload_bloc.dart';

class AddCategoryScreen extends StatefulWidget {
  final String? categoryId;

  const AddCategoryScreen({Key? key, this.categoryId}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _controller = TextEditingController();

  File? myImage;

  String? myImageFromNetwork;

  @override
  void initState() {
    final state = context.read<CategoriesBloc>().state;

    if (state is CategoriesFetchedState) {
      for (var element in state.categories) {
        if (element.categoryId == widget.categoryId) {
          _controller.text = element.name;
          myImageFromNetwork = element.image;
        }
      }
    }

    super.initState();
  }

  void _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source, maxWidth: 500);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper.platform.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 1000,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            statusBarColor: Colors.white,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.white,
            hideBottomControls: true,
          ),
        ],
      );

      if (croppedImage != null) {
        final image = File(croppedImage.path);

        setState(() {
          myImageFromNetwork = null;
          myImage = image;
        });
      }
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _uploading() {
    if ((myImage != null || myImageFromNetwork != null) && _controller.text.isNotEmpty) {
      context.read<CategoriesUploadBloc>().add(
            CategoriesUploadUpdateEvent(
              image: (myImageFromNetwork == null) ? myImage! : null,
              name: _controller.text,
              categoryId: widget.categoryId,
            ),
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              AspectRatio(
                aspectRatio: 1,
                child: InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: (myImage == null && myImageFromNetwork == null)
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: const Center(child: Text('Upload image')),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 0.5),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: (myImage == null)
                                ? Image.network(myImageFromNetwork!, fit: BoxFit.fill)
                                : Image.file(
                                    myImage!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(20),
                  labelText: 'Category name',
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<CategoriesUploadBloc, CategoriesUploadState>(
                listener: (context, state) {
                  Fluttertoast.showToast(msg: 'Category added', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
                  Navigator.of(context).pop();
                },
                listenWhen: (previous, current) => (previous is CategoriesUploadingState && current is CategoriesUploadInitialState),
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: (state is CategoriesUploadingState) ? null : _uploading,
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Theme.of(context).primaryColor)),
                        textStyle: const TextStyle(fontSize: 17),
                      ),
                      child: (state is CategoriesUploadingState)
                          ? const SizedBox(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2), height: 20, width: 20)
                          : const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
