import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplications_admin_app/logic/audio/audio_bloc.dart';
import 'package:supplications_admin_app/presentation/widgets/justAudioSlider.dart';

enum PlayerState {
  stopped,
  paused,
  playing,
}

class JustAudioWidget extends StatefulWidget {
  final String url;

  const JustAudioWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<JustAudioWidget> createState() => _JustAudioWidgetState();
}

class _JustAudioWidgetState extends State<JustAudioWidget> {
  AudioPlayer? _audioPlayer;

  PlayerState _playerState = PlayerState.stopped;

  _start() async {
    final duration = await _audioPlayer?.setUrl(widget.url);
    if (duration != null) {
      _audioPlayer?.play();
      setState(() {
        _playerState = PlayerState.playing;
      });
    }
  }

  _pause() async {
    if (_playerState == PlayerState.playing) {
      _audioPlayer?.pause();
      setState(() {
        _playerState = PlayerState.paused;
      });
    }
  }

  _play() async {
    if (_playerState == PlayerState.paused) {
      _audioPlayer?.play();
      setState(() {
        _playerState = PlayerState.playing;
      });
    }
  }

  _stopped() async {
    if (_playerState != PlayerState.stopped) {
      await _audioPlayer?.stop();
      setState(() {
        _playerState = PlayerState.stopped;
      });
      context.read<AudioBloc>().add(AudioStopEvent());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _audioPlayer = AudioPlayer();

    if (widget.url.isNotEmpty) {
      _start.call();
    }
  }

  @override
  void didUpdateWidget(covariant JustAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _audioPlayer?.stop();

    if (widget.url.isNotEmpty) {
      _start.call();
    }
  }

  @override
  void dispose() {
    _audioPlayer?.stop();
    _audioPlayer?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (_playerState == PlayerState.playing) ? null : _play,
                      icon: const Icon(Icons.play_arrow),
                      color: Colors.white,
                      disabledColor: Colors.white.withOpacity(0.6),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: (_playerState == PlayerState.paused) ? null : _pause,
                      icon: const Icon(Icons.pause),
                      color: Colors.white,
                      disabledColor: Colors.white.withOpacity(0.6),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: (_playerState == PlayerState.stopped) ? null : _stopped,
                      icon: const Icon(Icons.stop),
                      color: Colors.white,
                      disabledColor: Colors.white.withOpacity(0.6),
                      iconSize: 50,
                    ),
                  ],
                ),
              ),
              JustAudioSlider(audioPlayer: _audioPlayer),
            ],
          ),
        ),
      ),
    );
  }
}
