// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicModel _$PicModelFromJson(Map<String, dynamic> json) => PicModel(
      id: json['id'] as int,
      pic: json['pic'] as String,
      propertyName: json['propertyName'] as String,
      state: json['state'] as String,
      street: json['street'] as String,
      town: json['town'] as String,
      city: json['city'] as String,
      postcode: json['postcode'] as int,
      countryOfResidency: json['countryOfResidency'] as String,
      company: json['company'] as String,
      owner: json['owner'] as String,
      species:
          (json['species'] as List<dynamic>).map((e) => e as String).toList(),
      ngr: json['ngr'] as String,
    );

Map<String, dynamic> _$PicModelToJson(PicModel instance) => <String, dynamic>{
      'id': instance.id,
      'pic': instance.pic,
      'propertyName': instance.propertyName,
      'state': instance.state,
      'street': instance.street,
      'town': instance.town,
      'city': instance.city,
      'postcode': instance.postcode,
      'countryOfResidency': instance.countryOfResidency,
      'company': instance.company,
      'owner': instance.owner,
      'species': instance.species,
      'ngr': instance.ngr,
    };
