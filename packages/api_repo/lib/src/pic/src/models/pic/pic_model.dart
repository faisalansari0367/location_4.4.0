// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pic_model.g.dart';

@JsonSerializable()
class PicModel extends Equatable {
  final int id;
  final String pic;
  final String? propertyName;
  final String? state;
  final String? street;
  final String? town;
  final String? city;

  @JsonKey(fromJson: parseInt)
  final int? postcode;
  final String? countryOfResidency;
  final String? company;
  final String? owner;

  final String? lpaUsername;
  final String? lpaPassword;
  final String? nlisUsername;
  final String? nlisPassword;
  final String? msaNumber;
  final String? nfasAccreditationNumber;

  // @JsonKey(name: 'species', defaultValue: <String>[])
  // final List<String> species;
  final String? ngr;

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
    this.lpaUsername,
    this.lpaPassword,
    this.nlisUsername,
    this.nlisPassword,
    this.msaNumber,
    this.nfasAccreditationNumber,
    required this.ngr,
  });

  factory PicModel.fromJson(Map<String, dynamic> json) =>
      _$PicModelFromJson(json);

  static int? parseInt(dynamic value) => int.tryParse(value.toString());

  Map<String, dynamic> toJson() => _$PicModelToJson(this);

  // String get companies => company?.join(', ') ?? '';

  @override
  List<Object?> get props {
    return [
      id,
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
      lpaUsername,
      lpaPassword,
      nlisUsername,
      nlisPassword,
      msaNumber,
      nfasAccreditationNumber,
      ngr,
    ];
  }

  PicModel copyWith({
    int? id,
    String? pic,
    String? propertyName,
    String? state,
    String? street,
    String? town,
    String? city,
    int? postcode,
    String? countryOfResidency,
    String? company,
    String? owner,
    String? lpaUsername,
    String? lpaPassword,
    String? nlisUsername,
    String? nlisPassword,
    String? msaNumber,
    String? nfasAccreditationNumber,
    String? ngr,
  }) {
    return PicModel(
      id: id ?? this.id,
      pic: pic ?? this.pic,
      propertyName: propertyName ?? this.propertyName,
      state: state ?? this.state,
      street: street ?? this.street,
      town: town ?? this.town,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      countryOfResidency: countryOfResidency ?? this.countryOfResidency,
      company: company ?? this.company,
      owner: owner ?? this.owner,
      lpaUsername: lpaUsername ?? this.lpaUsername,
      lpaPassword: lpaPassword ?? this.lpaPassword,
      nlisUsername: nlisUsername ?? this.nlisUsername,
      nlisPassword: nlisPassword ?? this.nlisPassword,
      msaNumber: msaNumber ?? this.msaNumber,
      nfasAccreditationNumber: nfasAccreditationNumber ?? this.nfasAccreditationNumber,
      ngr: ngr ?? this.ngr,
    );
  }
}
