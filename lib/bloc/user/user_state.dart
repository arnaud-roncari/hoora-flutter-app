part of 'user_bloc.dart';

sealed class UserState {}

final class InitLoading extends UserState {}

final class InitSuccess extends UserState {}

final class GemsUpdate extends UserState {
  final int gems;

  GemsUpdate({required this.gems});
}

final class InitFailed extends UserState {
  final AlertException exception;

  InitFailed({required this.exception});
}
