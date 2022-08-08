// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'role_details_cubit.dart';

class RoleDetailsState extends Equatable {
  final List<FieldData> fields;
  final bool isLoading;
  
  const RoleDetailsState({this.isLoading = false, this.fields = const []});

  @override
  List<Object> get props => [fields, isLoading];

  RoleDetailsState copyWith({
    List<FieldData>? fields,
    bool? isLoading,
  }) {
    return RoleDetailsState(
      fields: fields ?? this.fields,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


