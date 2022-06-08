part of 'supplications_upload_bloc.dart';

abstract class SupplicationsUploadState extends Equatable {
  const SupplicationsUploadState();

  @override
  List<Object> get props => [];
}

class SupplicationsUploadInitialState extends SupplicationsUploadState {}

class SupplicationsUploadingState extends SupplicationsUploadState {}
