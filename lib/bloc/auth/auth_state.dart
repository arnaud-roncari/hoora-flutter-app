part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpWithGoogleLoading extends AuthState {}

class SignUpWithAppleLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  final bool isNewUser;

  SignUpSuccess({required this.isNewUser});
}

class SignUpFailed extends AuthState {}

class SignInLoading extends AuthState {}

class SignInWithGoogleLoading extends AuthState {}

class SignInWithAppleLoading extends AuthState {}

class SignInSuccess extends AuthState {
  final bool isNewUser;

  SignInSuccess({required this.isNewUser});
}

class SignInFailed extends AuthState {}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {}

class ForgotPasswordFailed extends AuthState {}
