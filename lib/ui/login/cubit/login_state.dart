// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isConnected = true,
    this.isLoading = false,
    this.error = '',
  });

  final String email;
  final String password;
  final bool isConnected;
  final bool isLoading;
  final String error;

  @override
  List<Object> get props => [email, password, isLoading, error, isConnected];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isConnected,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// class LoginInitial extends LoginState {}
