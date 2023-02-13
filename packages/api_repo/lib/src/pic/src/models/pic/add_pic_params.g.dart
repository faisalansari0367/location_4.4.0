// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pic_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPicParams _$AddPicParamsFromJson(Map<String, dynamic> json) => AddPicParams(
      pic: json['pic'] as String?,
      ngr: json['ngr'] as String?,
      companyName:
          (json['company'] as List<dynamic>?)?.map((e) => e as String).toList(),
      propertyName: json['property_name'] as String?,
      owner: json['owner'] as String?,
      street: json['street'] as String?,
      town: json['town'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
      lpaUsername: json['lpa_username'] as String?,
      lpaPassword: json['lpa_password'] as String?,
      nlisUsername: json['nlis_username'] as String?,
      nlisPassword: json['nlis_password'] as String?,
      msaNumber: json['msa_number'] as String?,
      nfasAccreditationNumber: json['nfas_accreditation_number'] as String?,
    );

Map<String, dynamic> _$AddPicParamsToJson(AddPicParams instance) =>
    <String, dynamic>{
      'pic': instance.pic,
      'ngr': instance.ngr,
      'company': instance.companyName,
      'property_name': instance.propertyName,
      'owner': instance.owner,
      'street': instance.street,
      'town': instance.town,
      'state': instance.state,
      'postcode': instance.postcode,
      'lpa_username': instance.lpaUsername,
      'lpa_password': instance.lpaPassword,
      'nlis_username': instance.nlisUsername,
      'nlis_password': instance.nlisPassword,
      'msa_number': instance.msaNumber,
      'nfas_accreditation_number': instance.nfasAccreditationNumber,
    };
