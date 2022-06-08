import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supplications_admin_app/data/models/supplication.dart';
import 'package:supplications_admin_app/logic/supplications_upload/supplications_upload_bloc.dart';

class AddSupplicationScreen extends StatefulWidget {
  final String categoryId;
  final Supplication? supplication;

  const AddSupplicationScreen({Key? key, required this.categoryId, this.supplication}) : super(key: key);

  @override
  State<AddSupplicationScreen> createState() => _AddSupplicationScreenState();
}

class _AddSupplicationScreenState extends State<AddSupplicationScreen> {
  final TextEditingController _arabicTextController = TextEditingController();
  final TextEditingController _englishTranslationController = TextEditingController();
  final TextEditingController _romanArabicController = TextEditingController();

  FilePickerResult? result;

  String? myAudio;

  @override
  void initState() {
    if (widget.supplication != null) {
      _arabicTextController.text = widget.supplication!.arabicText;
      _englishTranslationController.text = widget.supplication!.englishTranslation;
      _romanArabicController.text = widget.supplication!.romanArabic;
      myAudio = widget.supplication!.audio;
    }

    super.initState();
  }

  _pickAudioFile() async {
    result = await FilePicker.platform.pickFiles(type: FileType.audio);

    setState(() {});
  }

  _uploading() {
    if ((result != null || myAudio != null) && _arabicTextController.text.isNotEmpty && _englishTranslationController.text.isNotEmpty && _romanArabicController.text.isNotEmpty) {
      context.read<SupplicationsUploadBloc>().add(
            SupplicationsUploadUpdateEvent(
              arabicText: _arabicTextController.text,
              englishTranslation: _englishTranslationController.text,
              romanArabic: _romanArabicController.text,
              categoryId: widget.categoryId,
              audio: (result != null) ? File(result!.files.single.path!) : null,
              supplicationsId: (widget.supplication != null) ? widget.supplication!.supplicationId : null,
            ),
          );
    }
  }

  @override
  void dispose() {
    _arabicTextController.dispose();
    _englishTranslationController.dispose();
    _romanArabicController.dispose();
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
              InkWell(
                onTap: _pickAudioFile,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (result != null || myAudio != null) ? Colors.white : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: (result != null)
                      ? Padding(padding: const EdgeInsets.all(30.0), child: Center(child: Text(path.basename(result!.files.single.path!))))
                      : (myAudio != null)
                          ? Padding(padding: const EdgeInsets.all(30.0), child: Center(child: Text(path.basename(myAudio!))))
                          : const Padding(padding: EdgeInsets.all(30.0), child: Center(child: Text('Upload audio'))),
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _arabicTextController,
                textDirection: TextDirection.rtl,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(20),
                  labelText: 'Arabic Text',
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _englishTranslationController,
                textDirection: TextDirection.ltr,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(20),
                  labelText: 'English Translation',
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _romanArabicController,
                textDirection: TextDirection.ltr,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(20),
                  labelText: 'Roman Arabic',
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<SupplicationsUploadBloc, SupplicationsUploadState>(
                listener: (context, state) {
                  Fluttertoast.showToast(msg: 'Supplication added', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
                  Navigator.of(context).pop();
                },
                listenWhen: (previous, current) => (previous is SupplicationsUploadingState && current is SupplicationsUploadInitialState),
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: (state is SupplicationsUploadingState) ? null : _uploading,
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Theme.of(context).primaryColor)),
                        textStyle: const TextStyle(fontSize: 17),
                      ),
                      child: (state is SupplicationsUploadingState)
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
