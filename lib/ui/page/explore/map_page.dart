import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/city_model.dart';
import 'package:flutter_map/flutter_map.dart';

/// TODO retirer le padding en ahut
/// TODO changer la couleur du chargement de mapbox
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  // late MapboxMap mapboxMap;

  // onMapCreated(MapboxMap mapboxMap) {
  //   this.mapboxMap = mapboxMap;
  //   this.mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
  //   // this.mapboxMap.annotations.createCircleAnnotationManager()
  // }

  /// TODO régler le loading qui ne s'affiche pas
  @override
  Widget build(BuildContext context) {
    super.build(context);

    City selectedCity = context.read<ExploreBloc>().selectedCity;

    return BlocConsumer<ExploreBloc, ExploreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return FlutterMap(
          mapController: MapController(),
          options: MapOptions(
              initialCenter: selectedCity.getLatLng(),
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              )),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/devhoora/clulcc0x700le01nt1509c14f/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2aG9vcmEiLCJhIjoiY2x1bGMwcXQxMGpxNTJrbHcwMHlsb2FkMiJ9.QeSomxVwnjxWJBmmJA__FA',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedCity.getLatLng(),
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("é"),
                  ),
                ),
              ],
            ),
          ],
        );

        // return MapWidget(
        //   styleUri: MapboxStyles.DARK,
        //   key: const ValueKey("mapWidget"),
        //   onMapCreated: onMapCreated,
        //   cameraOptions: CameraOptions(
        //     center: Point(coordinates: selectedCity.getPosition()).toJson(),
        //     zoom: 13,
        //   ),
        // );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
