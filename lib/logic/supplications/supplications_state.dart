part of 'supplications_bloc.dart';

@immutable
abstract class SupplicationsState {}

class SupplicationsInitialState extends SupplicationsState {}

class SupplicationsLoadedState extends SupplicationsState {
  final List<Supplication> supplications;

  SupplicationsLoadedState({required this.supplications});
}

class SupplicationsFailedState extends SupplicationsState {}
