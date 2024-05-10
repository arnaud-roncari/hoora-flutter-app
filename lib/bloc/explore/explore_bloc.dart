import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/extension/hour_extension.dart';
import 'package:hoora/model/city_model.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/playlist_model.dart';
import 'package:hoora/model/region_model.dart';
import 'package:hoora/model/spot_model.dart';
import 'package:hoora/repository/crowd_report_repository.dart';
import 'package:hoora/repository/playlist_repository.dart';
import 'package:hoora/repository/region_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';
part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final RegionRepository areaRepository;
  final SpotRepository spotRepository;
  final PlaylistRepository playlistRepository;
  final CrashRepository crashRepository;
  final CrowdReportRepository crowdReportRepository;

  late List<Playlist> playlists;
  Playlist? selectedPlaylist;

  late List<Region> regions;
  late Region selectedRegion;
  City? selectedCity;

  late DateTime selectedDate;

  /// All spots fetched from the db.
  late List<Spot> spots;

  /// Filtered spots (displayed)
  late List<Spot> filteredSpots;

  ExploreBloc({
    required this.playlistRepository,
    required this.spotRepository,
    required this.areaRepository,
    required this.crashRepository,
    required this.crowdReportRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<PlaylistSelected>(playlistSelected);
    on<RegionSelected>(regionSelected);
    on<DateSelected>(dateSelected);
    on<HourSelected>(hourSelected);
    on<GetSpots>(getSpots);
  }

  void initialize(Init event, Emitter<ExploreState> emit) async {
    try {
      emit(InitLoading());
      List future = await Future.wait([
        playlistRepository.getPlaylists(),
        areaRepository.getAllRegions(),
      ]);

      /// Set and sort playlists, based on priority order.
      playlists = future[0];
      playlists.sort((a, b) {
        return a.priority.compareTo(b.priority);
      });

      /// Default selected area
      regions = future[1];
      selectedRegion = regions[0];

      /// Set a static, used for spots,
      Region.allRegions = regions;

      /// Default selected day and hour
      selectedDate = DateTime.now().copyWith(hour: DateTime.now().getFormattedHour());

      /// Then fetch spots
      spots = await spotRepository.getSpotsByRegion(selectedRegion, selectedCity);
      _filterSpots();

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void playlistSelected(PlaylistSelected event, Emitter<ExploreState> emit) async {
    selectedPlaylist = event.playlist;
    _filterSpots();
    emit(InitSuccess());
  }

  void regionSelected(RegionSelected event, Emitter<ExploreState> emit) async {
    selectedRegion = event.region;
    selectedCity = event.city;
    emit(CitySelectedUpdated());
    add(GetSpots());
  }

  void dateSelected(DateSelected event, Emitter<ExploreState> emit) async {
    selectedDate = event.date.copyWith(hour: selectedDate.hour, minute: 00);
    _filterSpots();
    emit(InitSuccess());
  }

  void hourSelected(HourSelected event, Emitter<ExploreState> emit) async {
    selectedDate = selectedDate.copyWith(hour: event.hour);
    _filterSpots();
    emit(InitSuccess());
  }

  //// Called when a new city is selected.
  void getSpots(GetSpots event, Emitter<ExploreState> emit) async {
    try {
      emit(GetSpotsLoading());
      spots = await spotRepository.getSpotsByRegion(selectedRegion, selectedCity);
      _filterSpots();
      emit(GetSpotsSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetSpotsFailed(exception: alertException));
    }
  }

  /// Filter spots based on gems, closing times and playlist.
  /// There is a unique case of filtering with the playlist "To" (10 best spots, based on score).
  void _filterSpots() async {
    List<Spot> filteredSpots = [];

    /// Unique filtering case for "Top" playlist.
    if (selectedPlaylist != null && selectedPlaylist!.name.toLowerCase().contains("top")) {
      for (int i = 0; i < spots.length; i++) {
        Spot spot = spots[i];
        if (!spot.isClosedAt(selectedDate)) {
          filteredSpots.add(spot);
        }
      }

      filteredSpots.sort((a, b) {
        return b.score.compareTo(a.score);
      });

      this.filteredSpots = filteredSpots.take(10).toList();
      return;
    }

    /// Standard playlist filtering.
    for (Spot spot in spots) {
      if (!spot.isClosedAt(selectedDate) && spot.hasPlaylist(selectedPlaylist)) {
        filteredSpots.add(spot);
      }
    }

    /// Descending order
    filteredSpots.sort((a, b) {
      int aGems = a.getGemsAt(selectedDate);
      int bGems = b.getGemsAt(selectedDate);

      /// Compare score if same amount of gems
      if (aGems == bGems) {
        return b.score.compareTo(a.score);
      }

      return bGems.compareTo(aGems);
    });

    this.filteredSpots = filteredSpots;
  }
}