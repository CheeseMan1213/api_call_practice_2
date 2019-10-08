// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TestCollectionObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestCollectionObject _$TestCollectionObjectFromJson(Map<String, dynamic> json) {
  return TestCollectionObject(
    json['firstName'] as String,
    json['lastName'] as String,
    json['ttime'] as String,
  )..id = json['_id'] as String;
}

Map<String, dynamic> _$TestCollectionObjectToJson(
        TestCollectionObject instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'ttime': instance.ttime,
    };
