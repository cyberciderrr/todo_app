// import 'package:dio/dio.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'flickr_service.g.dart';
//
// @JsonSerializable()
// class FlickrPhoto {
//   final String id;
//   final String owner;
//   final String secret;
//   final String server;
//   final int farm;
//   final String title;
//
//   FlickrPhoto({
//     required this.id,
//     required this.owner,
//     required this.secret,
//     required this.server,
//     required this.farm,
//     required this.title,
//   });
//
//   factory FlickrPhoto.fromJson(Map<String, dynamic> json) => _$FlickrPhotoFromJson(json);
//   Map<String, dynamic> toJson() => _$FlickrPhotoToJson(this);
// }
//
// @JsonSerializable()
// class FlickrResponse {
//   final int page;
//   final int pages;
//   final int perpage;
//   final int total;
//   final List<FlickrPhoto> photo;
//
//   FlickrResponse({
//     required this.page,
//     required this.pages,
//     required this.perpage,
//     required this.total,
//     required this.photo,
//   });
//
//   factory FlickrResponse.fromJson(Map<String, dynamic> json) => _$FlickrResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$FlickrResponseToJson(this);
// }
//
// class FlickrService {
//   final Dio _dio = Dio();
//   final String _apiKey = '997270535fe82de9b8d3f18201921055';
//
//   Future<FlickrResponse> searchPhotos(String query, int page) async {
//     final response = await _dio.get(
//       'https://api.flickr.com/services/rest/',
//       queryParameters: {
//         'method': 'flickr.photos.search',
//         'api_key': _apiKey,
//         'text': query,
//         'format': 'json',
//         'nojsoncallback': 1,
//         'page': page,
//       },
//     );
//
//     return FlickrResponse.fromJson(response.data['photos']);
//   }
//
//   String getPhotoUrl(FlickrPhoto photo) {
//     return 'https://farm${photo.farm}.staticflickr.com/${photo.server}/${photo.id}_${photo.secret}.jpg';
//   }
// }
