import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/repository/auth_repository.dart';
import 'package:hoora/repository/crash_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final CrashRepository crashRepository;

  AuthBloc({required this.authRepository, required this.crashRepository}) : super(AuthInitial()) {
    on<SignOut>(signOut);
    on<SignUp>(signUp);
    on<SignIn>(signIn);
    on<ForgotPassword>(forgotPassword);
    on<SignInWithApple>(signInWithApple);
    on<SignInWithGoogle>(signInWithGoogle);
    on<SignUpWithApple>(signUpWithApple);
    on<SignUpWithGoogle>(signUpWithGoogle);
  }

  void signOut(SignOut event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signOut();
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void forgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(ForgotPasswordLoading());
      await authRepository.forgotPassword(event.email);
      emit(ForgotPasswordSuccess());
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ForgotPasswordFailed(exception: alertException));
    }
  }

  void signIn(SignIn event, Emitter<AuthState> emit) async {
    try {
      emit(SignInLoading());
      await authRepository.signIn(event.email, event.password);
      emit(SignInSuccess(isNewUser: false));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signInWithApple(SignInWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithAppleLoading());
      bool isNewUser = await authRepository.signInWithApple();
      emit(SignInSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithGoogleLoading());
      bool isNewUser = await authRepository.signInWithGoogle();
      emit(SignInSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignInFailed(exception: alertException));
    }
  }

  void signUpWithApple(SignUpWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithAppleLoading());
      bool isNewUser = await authRepository.signInWithApple();
      emit(SignUpSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }

  void signUpWithGoogle(SignUpWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithGoogleLoading());
      bool isNewUser = await authRepository.signInWithGoogle();
      emit(SignUpSuccess(isNewUser: isNewUser));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }

  void signUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpLoading());
      await authRepository.signUp(event.email, event.password);
      emit(SignUpSuccess(isNewUser: true));
    } catch (exception, stack) {
      /// Report crash to Crashlytics
      crashRepository.report(exception, stack);

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SignUpFailed(exception: alertException));
    }
  }
}
