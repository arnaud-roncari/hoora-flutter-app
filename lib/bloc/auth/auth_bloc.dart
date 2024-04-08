import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
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
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignInFailed(exception: exception));
    }
  }

  void forgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(ForgotPasswordLoading());
      await authRepository.forgotPassword(event.email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(ForgotPasswordFailed(exception: exception));
    }
  }

  void signIn(SignIn event, Emitter<AuthState> emit) async {
    try {
      emit(SignInLoading());
      await authRepository.signIn(event.email, event.password);
      emit(SignInSuccess(isNewUser: false));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignInFailed(exception: exception));
    }
  }

  void signInWithApple(SignInWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithAppleLoading());
      UserCredential user = await authRepository.signInWithApple();
      emit(SignInSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignInFailed(exception: exception));
    }
  }

  void signInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignInWithGoogleLoading());
      UserCredential user = await authRepository.signInWithGoogle();
      emit(SignInSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignInFailed(exception: exception));
    }
  }

  void signUpWithApple(SignUpWithApple event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithAppleLoading());
      UserCredential user = await authRepository.signInWithApple();
      emit(SignUpSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignUpFailed(exception: exception));
    }
  }

  void signUpWithGoogle(SignUpWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpWithGoogleLoading());
      UserCredential user = await authRepository.signInWithGoogle();
      emit(SignUpSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignUpFailed(exception: exception));
    }
  }

  void signUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpLoading());
      await authRepository.signUp(event.email, event.password);
      emit(SignUpSuccess(isNewUser: true));
    } catch (e) {
      /// TODO Save exception in db (code, stacktrace).
      AlertException exception = AlertException.fromException(e);
      emit(SignUpFailed(exception: exception));
    }
  }
}
