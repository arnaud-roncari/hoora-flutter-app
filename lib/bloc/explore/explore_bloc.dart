import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/repository/category_repository.dart';
import 'package:hoora/repository/city_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';
import 'package:hoora/repository/user_repository.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final UserRepository userRepository;
  final CityRepository cityRepository;
  final SpotRepository spotRepository;
  final CategoryRepository categoryRepository;
  final CrashRepository crashRepository;

  late List<Category> categories;
  late Category selectedCategory;

  late List<City> cities;
  late City selectedCity;

  late DateTime selectedDate;

  ExploreBloc({
    required this.categoryRepository,
    required this.spotRepository,
    required this.userRepository,
    required this.cityRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Initialize>(initialize);
    on<CategorySelected>(categorySelected);
    on<CitySelected>(citySelected);
    on<DateSelected>(dateSelected);
  }

  void initialize(Initialize event, Emitter<ExploreState> emit) async {
    try {
      emit(InitLoading());
      List future = await Future.wait([
        categoryRepository.getCategories(),
        cityRepository.getAllCities(),
      ]);

      categories = future[0];
      selectedCategory = categories.first;

      cities = future[1];
      selectedCity = cities[0];

      selectedDate = DateTime.now();

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void categorySelected(CategorySelected event, Emitter<ExploreState> emit) async {
    try {
      selectedCategory = event.category;
      emit(GetSpotsLoading());

      await Future.delayed(const Duration(seconds: 1));

      /// TODO ftech post(category, city)
      emit(GetSpotsSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetSpotsFailed(exception: alertException));
    }
  }

  void citySelected(CitySelected event, Emitter<ExploreState> emit) async {
    try {
      selectedCity = event.city;
      emit(GetSpotsLoading());

      await Future.delayed(const Duration(seconds: 1));

      /// TODO ftech post(category, city)
      emit(GetSpotsSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetSpotsFailed(exception: alertException));
    }
  }

  void dateSelected(DateSelected event, Emitter<ExploreState> emit) async {
    selectedDate = event.date;

    /// TODO filtrer les spots du jourw
    emit(InitSuccess());
  }
}
