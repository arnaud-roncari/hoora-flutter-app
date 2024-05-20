part of 'ranking_bloc.dart';

sealed class RankingEvent {}

final class Init extends RankingEvent {
  final User user;

  Init({required this.user});
}
