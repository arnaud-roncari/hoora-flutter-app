import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
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

  late DateTime actualDate;

  /// All spots fetched from the db.
  late List<Spot> spots;

  /// Filtered spots (displayed)
  late List<Spot> filteredSpots;

  MapBloc({
    required this.playlistRepository,
    required this.spotRepository,
    required this.areaRepository,
    required this.crashRepository,
    required this.crowdReportRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<PlaylistSelected>(playlistSelected);
    on<RegionSelected>(regionSelected);
    on<GetSpots>(getSpots);
    on<UpdateDate>(updateDate);
  }

  void initialize(Init event, Emitter<MapState> emit) async {
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

      /// Set a static, used for spots (duplicated for now)
      Region.allRegions = regions;

      /// Default selected day
      actualDate = DateTime.now();

      /// Then fetch spots
      await _fetchSpots(emit);

      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  Future<void> _fetchSpots(Emitter<MapState> emit) async {
    try {
      await for (List<Spot> spotList in spotRepository.getAllSpots()) {
        spots = spotList;
        print('Spots updated:');
        for (Spot spot in spots) {
          print(spot.name);
        }
        _filterSpots();
        emit(GetSpotsSuccess());
      }
    } catch (error) {
      AlertException alertException = AlertException.fromException(error);
      emit(GetSpotsFailed(exception: alertException));
    }
  }

  void playlistSelected(PlaylistSelected event, Emitter<MapState> emit) async {
    selectedPlaylist = event.playlist;
    _filterSpots();
    emit(InitSuccess());
  }

  void regionSelected(RegionSelected event, Emitter<MapState> emit) async {
    selectedRegion = event.region;
    selectedCity = event.city;
    emit(CitySelectedUpdated());
    await _fetchSpots(emit);
  }

  void getSpots(GetSpots event, Emitter<MapState> emit) async {
    emit(GetSpotsLoading());
    await _fetchSpots(emit);
  }

  void updateDate(UpdateDate event, Emitter<MapState> emit) async {
    actualDate = event.date;
    emit(InitSuccess());
  }

  /// Filter spots based on gems, closing times and playlist.
  /// There is a unique case of filtering with the playlist "Top" (10
  /// best spots, based on score).
  /// PS: This one is different from explore page.
  void _filterSpots() {
    List<Spot> filteredSpots = [];

    /// Unique filtering case for "Top" playlist.
    if (selectedPlaylist != null && selectedPlaylist!.name.toLowerCase().contains("top")) {
      filteredSpots = List.from(spots);

      filteredSpots.sort((a, b) {
        return b.score.compareTo(a.score);
      });

      this.filteredSpots = filteredSpots.take(10).toList();
      return;
    }

    /// Standard playlist filtering.
    for (Spot spot in spots) {
      if (spot.hasPlaylist(selectedPlaylist)) {
        filteredSpots.add(spot);
      }
    }

    this.filteredSpots = filteredSpots;
  }
}
