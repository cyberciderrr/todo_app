// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flickr_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlickrPhotoModel _$FlickrPhotoModelFromJson(Map<String, dynamic> json) =>
    FlickrPhotoModel(
      id: json['id'] as String,
      owner: json['owner'] as String,
      secret: json['secret'] as String,
      server: json['server'] as String,
      farm: (json['farm'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$FlickrPhotoModelToJson(FlickrPhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'secret': instance.secret,
      'server': instance.server,
      'farm': instance.farm,
      'title': instance.title,
    };

FlickrResponseModel _$FlickrResponseModelFromJson(Map<String, dynamic> json) =>
    FlickrResponseModel(
      page: (json['page'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      perpage: (json['perpage'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      photo: (json['photo'] as List<dynamic>)
          .map((e) => FlickrPhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlickrResponseModelToJson(
        FlickrResponseModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pages': instance.pages,
      'perpage': instance.perpage,
      'total': instance.total,
      'photo': instance.photo,
    };
