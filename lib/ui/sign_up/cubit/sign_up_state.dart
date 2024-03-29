// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String countryCode;
  final String countryOfResidency;
  final bool termsAndConditions;

  const SignUpState({
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.password = '',
    this.countryCode = '',
    this.countryOfResidency = '',
    this.termsAndConditions = false,
  });

  @override
  List<Object> get props => [email, firstName, lastName, phoneNumber, password, termsAndConditions, countryCode, countryOfResidency];

  SignUpState copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? password,
    String? countryCode,
    String? countryOfResidency,
    bool? termsAndConditions,
  }) {
    return SignUpState(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      countryCode: countryCode ?? this.countryCode,
      countryOfResidency: countryOfResidency ?? this.countryOfResidency,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    );
  }
}
