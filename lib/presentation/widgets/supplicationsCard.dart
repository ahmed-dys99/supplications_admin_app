import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supplications_admin_app/data/models/supplication.dart';
import 'package:supplications_admin_app/logic/audio/audio_bloc.dart';
import 'package:supplications_admin_app/logic/supplications_upload/supplications_upload_bloc.dart';
import 'package:supplications_admin_app/presentation/screens/addSupplicationScreen.dart';

class SupplicationCard extends StatefulWidget {
  final Supplication supplication;

  const SupplicationCard({Key? key, required this.supplication}) : super(key: key);

  @override
  State<SupplicationCard> createState() => _SupplicationCardState();
}

class _SupplicationCardState extends State<SupplicationCard> {
  Offset? _tapDownPosition;

  _openEdit() {
    Future.delayed(const Duration(seconds: 0), () {
      context.read<AudioBloc>().add(AudioStopEvent());

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AddSupplicationScreen(
            categoryId: widget.supplication.categoryId,
            supplication: widget.supplication,
          ),
        ),
      );
    });
  }

  _openDelete() {
    Future.delayed(const Duration(seconds: 0), () {
      context.read<AudioBloc>().add(AudioStopEvent());

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
              'Are you sure want to delete this supplication?',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('No')),
              TextButton(
                onPressed: () {
                  context.read<SupplicationsUploadBloc>().add(
                        SupplicationsUploadDeleteEvent(
                          supplicationId: widget.supplication.supplicationId,
                          categoryId: widget.supplication.categoryId,
                        ),
                      );
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _tapDownPosition = details.globalPosition,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey, width: 0.2),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              context.read<AudioBloc>().add(AudioStartEvent(url: widget.supplication.audio));
            },
            onLongPress: () {
              final RenderBox? overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  _tapDownPosition!.dx,
                  _tapDownPosition!.dy,
                  overlay!.size.width - _tapDownPosition!.dx,
                  overlay.size.height - _tapDownPosition!.dy,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                items: [
                  PopupMenuItem(
                    onTap: () {
                      _openEdit.call();
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 22, color: Color(0xFF666666)),
                        SizedBox(width: 8),
                        Text("Edit", style: TextStyle(color: Color(0xFF666666), fontSize: 15)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      _openDelete.call();
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 22, color: Color(0xFF666666)),
                        SizedBox(width: 8),
                        Text("Delete", style: TextStyle(color: Color(0xFF666666), fontSize: 15)),
                      ],
                    ),
                  )
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.supplication.arabicText,
                      style: GoogleFonts.notoSansArabic(
                        fontSize: 15,
                        height: 2,
                        color: const Color.fromRGBO(51, 51, 51, 1),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.supplication.englishTranslation,
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Color.fromRGBO(51, 51, 51, 1)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.supplication.romanArabic,
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Color.fromRGBO(119, 119, 119, 1)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        elevation: 1,
                        color: const Color.fromRGBO(85, 85, 85, 1),
                        margin: const EdgeInsets.only(top: 16, right: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.play_arrow, color: Colors.white, size: 25),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
