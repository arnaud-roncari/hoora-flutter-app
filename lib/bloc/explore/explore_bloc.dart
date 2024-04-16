import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/spot_model.dart';
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

  late int selectedHour;

  late List<Spot> spots;

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
    on<HourSelected>(hourSelected);
    on<GetSpots>(getSpots);
  }

  void initialize(Initialize event, Emitter<ExploreState> emit) async {
    try {
      emit(InitLoading());
      List future = await Future.wait([
        categoryRepository.getCategories(),
        cityRepository.getAllCities(),
      ]);

      /// Default selected category
      categories = future[0];
      selectedCategory = categories.first;

      /// Default selected city
      cities = future[1];
      selectedCity = cities[0];

      /// Default selected day
      selectedDate = DateTime.now();

      /// Default selected hour;
      selectedHour = 7;

      /// Then fetch spots
      spots = await spotRepository.getSpots(selectedCity, selectedCategory);
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
    selectedCategory = event.category;
    add(GetSpots());
  }

  void citySelected(CitySelected event, Emitter<ExploreState> emit) async {
    selectedCity = event.city;
    add(GetSpots());
  }

  void dateSelected(DateSelected event, Emitter<ExploreState> emit) async {
    selectedDate = event.date;

    /// TODO filtrer les spots du jour (remove emit)
    emit(InitSuccess());
  }

  void hourSelected(HourSelected event, Emitter<ExploreState> emit) async {
    selectedHour = event.hour;

    /// TODO filtrer les spots du jour (remove emit)
    emit(InitSuccess());
  }

  void getSpots(GetSpots event, Emitter<ExploreState> emit) async {
    try {
      emit(GetSpotsLoading());
      spots = await spotRepository.getSpots(selectedCity, selectedCategory);

      /// TODO remove me
      await Future.delayed(const Duration(seconds: 1));
      emit(GetSpotsSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetSpotsFailed(exception: alertException));
    }
  }
}
