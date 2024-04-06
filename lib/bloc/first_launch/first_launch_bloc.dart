import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoora/common/globals.dart';

part 'first_launch_event.dart';
part 'first_launch_state.dart';

class FirstLaunchBloc extends Bloc<FirstLaunchEvent, FirstLaunchState> {
  FirstLaunchBloc() : super(FirstLaunchInitial()) {
    on<RequestGeolocation>(getGeolocation);
    on<SetFirstLaunch>(setFirstLaunch);
  }

  void setFirstLaunch(SetFirstLaunch event, Emitter<FirstLaunchState> emit) async {
    await const FlutterSecureStorage().write(key: kSSKeyFirstLaunch, value: "false");
    emit(FirstLaunchSet());
  }

  void getGeolocation(RequestGeolocation event, Emitter<FirstLaunchState> emit) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(GeolocationDenied());
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        emit(GeolocationDenied());
      }
    }

    emit(GeolocationAccepted());
  }
}
