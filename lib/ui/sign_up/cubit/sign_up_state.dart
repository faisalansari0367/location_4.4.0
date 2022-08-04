// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;

  const SignUpState({
    this.password = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
  });

  @override
  List<Object> get props => [email, firstName, lastName, phoneNumber, password];

  SignUpState copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? password,
  }) {
    return SignUpState(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}
