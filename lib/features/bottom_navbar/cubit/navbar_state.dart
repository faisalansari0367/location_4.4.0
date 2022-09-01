// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// part of 'navbar_cubit.dart';
part 'navbar_state.g.dart';

@JsonSerializable()
class NavbarState extends Equatable {
  const NavbarState({this.index = 0, this.reverse = false});

  final int index;
  final bool reverse;

  @override
  List<Object?> get props => [index];

  NavbarState copyWith({
    int? index,
    bool? reverse,
  }) {
    return NavbarState(
      index: index ?? this.index,
      reverse: reverse ?? this.reverse,
    );
  }

  factory NavbarState.fromJson(Map<String, dynamic> json) => _$NavbarStateFromJson(json);

  Map<String, dynamic>? toJson(NavbarState state) => _$NavbarStateToJson(this);
}
