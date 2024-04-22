import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/category_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/model/user_model.dart';
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
  Category? selectedCategory;

  late List<City> cities;
  late City selectedCity;

  late DateTime selectedDate;

  late int selectedHour;

  late User user;

  /// All spots fetched from the db.
  /// Spots are filtered by category, closed hours and gems.
  late List<Spot> _spots;
  late List<Spot> filteredSpots;

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
        userRepository.getUser(),
      ]);

      categories = future[0];

      /// Default selected city
      cities = future[1];
      selectedCity = cities[0];

      /// Default user
      user = future[2];

      /// Default selected day
      selectedDate = DateTime.now();

      /// Default selected hour;
      selectedHour = DateTime.now().hour;
      if (selectedHour < 7 || selectedHour > 21) {
        selectedHour = 7;
      }

      /// Then fetch spots
      _spots = await spotRepository.getSpots(selectedCity);
      _filterAllSpots();

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
    _filterAllSpots();
    emit(InitSuccess());
  }

  void citySelected(CitySelected event, Emitter<ExploreState> emit) async {
    selectedCity = event.city;
    add(GetSpots());
  }

  void dateSelected(DateSelected event, Emitter<ExploreState> emit) async {
    selectedDate = event.date;
    _filterAllSpots();
    emit(InitSuccess());
  }

  void hourSelected(HourSelected event, Emitter<ExploreState> emit) async {
    selectedHour = event.hour;
    _filterAllSpots();
    emit(InitSuccess());
  }

  void getSpots(GetSpots event, Emitter<ExploreState> emit) async {
    try {
      emit(GetSpotsLoading());
      _spots = await spotRepository.getSpots(selectedCity);
      _filterAllSpots();
      emit(GetSpotsSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetSpotsFailed(exception: alertException));
    }
  }

  /// Filter and sort all spots.
  void _filterAllSpots() {
    List<Spot> filteredSpots = [];

    for (Spot spot in _spots) {
      if (!spot.isClosedAt(selectedDate, selectedHour) && spot.hasCategory(selectedCategory)) {
        filteredSpots.add(spot);
      }
    }

    /// Descending order
    filteredSpots.sort((a, b) {
      return b
          .getGemsAt(
            selectedDate,
            selectedHour,
          )
          .compareTo(
            a.getGemsAt(
              selectedDate,
              selectedHour,
            ),
          );
    });

    this.filteredSpots = filteredSpots;
  }
}
