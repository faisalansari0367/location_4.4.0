// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_pic_params.g.dart';

@JsonSerializable()
class AddPicParams extends Equatable {
  final String? pic;
  final String? ngr;

  @JsonKey(name: 'company')
  final List<String>? companyName;

  @JsonKey(name: 'property_name')
  final String? propertyName;
  final String? owner;
  final String? street;
  final String? town;
  final String? state;

  @JsonKey(name: 'postcode')
  final String? postcode;

  @JsonKey(name: 'lpa_username')
  final String? lpaUsername;

  @JsonKey(name: 'lpa_password')
  final String? lpaPassword;

  @JsonKey(name: 'nlis_username')
  final String? nlisUsername;

  @JsonKey(name: 'nlis_password')
  final String? nlisPassword;

  @JsonKey(name: 'msa_number')
  final String? msaNumber;

  @JsonKey(name: 'nfas_accreditation_number')
  final String? nfasAccreditationNumber;

  const AddPicParams({
    this.pic,
    this.ngr,
    this.companyName,
    this.propertyName,
    this.owner,
    this.street,
    this.town,
    this.state,
    this.postcode,
    this.lpaUsername,
    this.lpaPassword,
    this.nlisUsername,
    this.nlisPassword,
    this.msaNumber,
    this.nfasAccreditationNumber,
  });

  factory AddPicParams.fromJson(Map<String, dynamic> json) =>
      _$AddPicParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AddPicParamsToJson(this);

  AddPicParams copyWith({
    String? pic,
    String? ngr,
    List<String>? companyName,
    String? propertyName,
    String? owner,
    String? street,
    String? town,
    String? state,
    String? postcode,
    String? lpaUsername,
    String? lpaPassword,
    String? nlisUsername,
    String? nlisPassword,
    String? msaNumber,
    String? nfasAccreditationNumber,
  }) {
    return AddPicParams(
      pic: pic ?? this.pic,
      ngr: ngr ?? this.ngr,
      companyName: companyName ?? this.companyName,
      propertyName: propertyName ?? this.propertyName,
      owner: owner ?? this.owner,
      street: street ?? this.street,
      town: town ?? this.town,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      lpaUsername: lpaUsername ?? this.lpaUsername,
      lpaPassword: lpaPassword ?? this.lpaPassword,
      nlisUsername: nlisUsername ?? this.nlisUsername,
      nlisPassword: nlisPassword ?? this.nlisPassword,
      msaNumber: msaNumber ?? this.msaNumber,
      nfasAccreditationNumber: nfasAccreditationNumber ?? this.nfasAccreditationNumber,
    );
  }

  @override
  List<Object?> get props {
    return [
      pic,
      ngr,
      companyName,
      propertyName,
      owner,
      street,
      town,
      state,
      postcode,
      lpaUsername,
      lpaPassword,
      nlisUsername,
      nlisPassword,
      msaNumber,
      nfasAccreditationNumber,
    ];
  }
}
