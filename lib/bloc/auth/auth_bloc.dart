import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    await authRepository.signOut();
  }

  void forgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoading());
    await authRepository.forgotPassword(event.email);
    emit(ForgotPasswordSuccess());
  }

  void signIn(SignIn event, Emitter<AuthState> emit) async {
    emit(SignInLoading());
    await authRepository.signIn(event.email, event.password);
    emit(SignInSuccess(isNewUser: false));
  }

  void signInWithApple(SignInWithApple event, Emitter<AuthState> emit) async {
    emit(SignInWithAppleLoading());
    UserCredential user = await authRepository.signInWithApple();
    emit(SignInSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
  }

  void signInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(SignInWithGoogleLoading());
    UserCredential user = await authRepository.signInWithGoogle();
    emit(SignInSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
  }

  void signUpWithApple(SignUpWithApple event, Emitter<AuthState> emit) async {
    emit(SignUpWithAppleLoading());
    UserCredential user = await authRepository.signInWithApple();
    emit(SignUpSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
  }

  void signUpWithGoogle(SignUpWithGoogle event, Emitter<AuthState> emit) async {
    emit(SignUpWithGoogleLoading());
    UserCredential user = await authRepository.signInWithGoogle();
    emit(SignUpSuccess(isNewUser: user.additionalUserInfo!.isNewUser));
  }

  void signUp(SignUp event, Emitter<AuthState> emit) async {
    emit(SignUpLoading());
    await authRepository.signUp(event.email, event.password);
    emit(SignUpSuccess(isNewUser: true));
    // emit(SignUpFailed());
  }
}
