// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pic_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPicParams _$AddPicParamsFromJson(Map<String, dynamic> json) => AddPicParams(
      pic: json['pic'] as String?,
      ngr: json['ngr'] as String?,
      companyName: json['companyName'] as String?,
      propertyName: json['propertyName'] as String?,
      owner: json['owner'] as String?,
      street: json['street'] as String?,
      town: json['town'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
    );

Map<String, dynamic> _$AddPicParamsToJson(AddPicParams instance) =>
    <String, dynamic>{
      'pic': instance.pic,
      'ngr': instance.ngr,
      'companyName': instance.companyName,
      'propertyName': instance.propertyName,
      'owner': instance.owner,
      'street': instance.street,
      'town': instance.town,
      'state': instance.state,
      'postcode': instance.postcode,
    };
