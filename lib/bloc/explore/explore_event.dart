part of 'explore_bloc.dart';

sealed class ExploreEvent {}

final class Initialize extends ExploreEvent {}

final class CategorySelected extends ExploreEvent {
  final Category category;

  CategorySelected({required this.category});
}

final class CitySelected extends ExploreEvent {
  final City city;

  CitySelected({required this.city});
}

final class DateSelected extends ExploreEvent {
  final DateTime date;

  DateSelected({required this.date});
}
