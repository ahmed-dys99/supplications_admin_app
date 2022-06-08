part of 'audio_bloc.dart';

@immutable
abstract class AudioEvent extends Equatable {}

class AudioStartEvent extends AudioEvent {
  final String url;

  AudioStartEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class AudioStopEvent extends AudioEvent {
  @override
  List<Object?> get props => [];
}
