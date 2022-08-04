part of 'login_cubit.dart';

class LoginState extends Equatable {
  
  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error = '',
  });

  final String email;
  final String password;
  final bool isLoading;
  final String error;


  @override
  List<Object> get props => [email, password, isLoading, error];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// class LoginInitial extends LoginState {}
