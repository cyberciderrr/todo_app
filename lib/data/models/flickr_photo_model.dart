import 'package:json_annotation/json_annotation.dart';

part 'flickr_photo_model.g.dart';

@JsonSerializable()
class FlickrPhotoModel {
  final String id;
  final String owner;
  final String secret;
  final String server;
  final int farm;
  final String title;

  FlickrPhotoModel({
    required this.id,
    required this.owner,
    required this.secret,
    required this.server,
    required this.farm,
    required this.title,
  });

  factory FlickrPhotoModel.fromJson(Map<String, dynamic> json) => _$FlickrPhotoModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlickrPhotoModelToJson(this);
}

@JsonSerializable()
class FlickrResponseModel {
  final int page;
  final int pages;
  final int perpage;
  final int total;
  final List<FlickrPhotoModel> photo;

  FlickrResponseModel({
    required this.page,
    required this.pages,
    required this.perpage,
    required this.total,
    required this.photo,
  });

  factory FlickrResponseModel.fromJson(Map<String, dynamic> json) => _$FlickrResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlickrResponseModelToJson(this);
}
