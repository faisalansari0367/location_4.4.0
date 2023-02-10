// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:json_annotation/json_annotation.dart';

part 'add_pic_params.g.dart';

@JsonSerializable()
class AddPicParams {
  final String? pic;
  final String? ngr;
  final String? companyName;
  final String? propertyName;
  final String? owner;
  final String? street;
  final String? town;
  final String? state;
  final String? postcode;

  AddPicParams({
    this.pic,
    this.ngr,
    this.companyName,
    this.propertyName,
    this.owner,
    this.street,
    this.town,
    this.state,
    this.postcode,
  });

  

  factory AddPicParams.fromJson(Map<String, dynamic> json) => _$AddPicParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AddPicParamsToJson(this);

  AddPicParams copyWith({
    String? pic,
    String? ngr,
    String? companyName,
    String? propertyName,
    String? owner,
    String? street,
    String? town,
    String? state,
    String? postcode,
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
    );
  }
}
