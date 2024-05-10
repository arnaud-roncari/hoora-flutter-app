import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/model/user_model.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final CrashRepository crashRepository;

  late User user;

  UserBloc({
    required this.userRepository,
    required this.crashRepository,
  }) : super(InitLoading()) {
    on<Init>(initialize);
    on<GemsEarned>(updateGems);
  }

  void initialize(Init event, Emitter<UserState> emit) async {
    try {
      emit(InitLoading());
      user = await userRepository.getUser();
      emit(InitSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitFailed(exception: alertException));
    }
  }

  void updateGems(GemsEarned event, Emitter<UserState> emit) {
    user.gem += event.amount;
    emit(GemsUpdate(gems: user.gem));
  }
}
