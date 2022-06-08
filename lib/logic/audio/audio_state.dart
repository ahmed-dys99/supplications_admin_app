part of 'audio_bloc.dart';

@immutable
abstract class AudioState extends Equatable {}

class AudioInitialState extends AudioState {
  @override
  List<Object?> get props => [];
}

class AudioStartedState extends AudioState {
  final String url;

  AudioStartedState({required this.url});

  @override
  List<Object?> get props => [url];
}
