import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class JustAudioSlider extends StatefulWidget {
  const JustAudioSlider({Key? key, required AudioPlayer? audioPlayer})
      : _audioPlayer = audioPlayer,
        super(key: key);

  final AudioPlayer? _audioPlayer;

  @override
  State<JustAudioSlider> createState() => _JustAudioSliderState();
}

class _JustAudioSliderState extends State<JustAudioSlider> {
  Duration? _duration;
  Duration? _position;

  final ValueNotifier<double> _durationNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _positionNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> _positionNotifierWhileDragging = ValueNotifier(0.0);

  bool draggingSlider = false;

  changePosition(double value) async {
    draggingSlider = false;

    final int seekTo = (_duration!.inMicroseconds * value).toInt();

    await widget._audioPlayer!.seek(Duration(microseconds: seekTo));

    _positionNotifier.value = _positionNotifierWhileDragging.value;

    setState(() {});
  }

  slidePosition(double value) async {
    _positionNotifierWhileDragging.value = value;
    if (_duration != null) {
      _position = Duration(microseconds: (_duration!.inMicroseconds * value).toInt());
    }
  }

  Timer? audioBuffering;

  _attachListenersToAudioPlayer() {
    widget._audioPlayer?.durationStream.listen((Duration? d) {
      if (d != null) {
        _duration = d;
        _durationNotifier.value = (_duration != null) ? _duration!.inMilliseconds.toDouble() : 0.0;
      }
    });

    widget._audioPlayer?.positionStream.listen((Duration p) {
      if (draggingSlider == false) {
        _position = p;
        _positionNotifier.value = (_position != null && _duration != null) ? (_position!.inMicroseconds / _duration!.inMicroseconds) : 0;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _attachListenersToAudioPlayer();
  }

  @override
  void didUpdateWidget(covariant JustAudioSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    _attachListenersToAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white38,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              trackHeight: 3,
              overlayShape: const RoundSliderThumbShape(enabledThumbRadius: 7, elevation: 0, pressedElevation: 0),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            ),
            child: ValueListenableBuilder(
              valueListenable: draggingSlider ? _positionNotifierWhileDragging : _positionNotifier,
              builder: (context, double value, __) {
                return Slider(
                  value: (value < 1) ? value : 1,
                  onChangeStart: (double value) {
                    setState(() {
                      draggingSlider = true;
                    });
                  },
                  onChanged: (double value) {
                    slidePosition(value);
                  },
                  onChangeEnd: (double value) {
                    changePosition(value);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                valueListenable: (draggingSlider) ? _positionNotifierWhileDragging : _positionNotifier,
                builder: (context, double value, _) {
                  if (_position == null) {
                    return const Center(
                      child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                    );
                  }
                  return Text("${_position!.inMinutes}:${_position!.inSeconds % 60}", style: const TextStyle(color: Colors.white));
                },
              ),
              ValueListenableBuilder(
                valueListenable: _durationNotifier,
                builder: (context, double value, _) {
                  if (_duration == null) {
                    return const SizedBox.shrink();
                  }
                  return Text("${_duration!.inMinutes}:${_duration!.inSeconds % 60}", style: const TextStyle(color: Colors.white));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
