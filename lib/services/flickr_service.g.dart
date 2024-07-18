// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flickr_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlickrPhoto _$FlickrPhotoFromJson(Map<String, dynamic> json) => FlickrPhoto(
      id: json['id'] as String,
      owner: json['owner'] as String,
      secret: json['secret'] as String,
      server: json['server'] as String,
      farm: (json['farm'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$FlickrPhotoToJson(FlickrPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'secret': instance.secret,
      'server': instance.server,
      'farm': instance.farm,
      'title': instance.title,
    };

FlickrResponse _$FlickrResponseFromJson(Map<String, dynamic> json) =>
    FlickrResponse(
      page: (json['page'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
      perpage: (json['perpage'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      photo: (json['photo'] as List<dynamic>)
          .map((e) => FlickrPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlickrResponseToJson(FlickrResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pages': instance.pages,
      'perpage': instance.perpage,
      'total': instance.total,
      'photo': instance.photo,
    };
