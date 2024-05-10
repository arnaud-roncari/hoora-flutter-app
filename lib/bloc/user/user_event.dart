part of 'user_bloc.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class GemsEarned extends UserEvent {
  final int amount;

  GemsEarned({required this.amount});
}
