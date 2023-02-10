// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pic_model.g.dart';

@JsonSerializable()
class PicModel extends Equatable {
  final int id;
  final String pic;
  final String propertyName;
  final String state;
  final String street;
  final String town;
  final String? city;

  @JsonKey(fromJson: parseInt)
  final int postcode;
  final String? countryOfResidency;
  final String? company;
  final String? owner;

  @JsonKey(name: 'species', defaultValue: <String>[])
  final List<String> species;
  final String ngr;

  const PicModel({
    required this.id,
    required this.pic,
    required this.propertyName,
    required this.state,
    required this.street,
    required this.town,
    required this.city,
    required this.postcode,
    required this.countryOfResidency,
    required this.company,
    required this.owner,
    required this.species,
    required this.ngr,
  });

  factory PicModel.fromJson(Map<String, dynamic> json) =>
      _$PicModelFromJson(json);

  static int parseInt(dynamic value) {
    return int.parse(value.toString());
  }

  Map<String, dynamic> toJson() => _$PicModelToJson(this);

  @override
  List<Object?> get props {
    return [
      pic,
      propertyName,
      state,
      street,
      town,
      city,
      postcode,
      countryOfResidency,
      company,
      owner,
      species,
      ngr,
    ];
  }
}
