import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc() : super(AudioInitialState()) {
    on<AudioStartEvent>((event, emit) {
      emit(AudioStartedState(url: event.url));
    });
    on<AudioStopEvent>((event, emit) {
      emit(AudioInitialState());
    });
  }
}
