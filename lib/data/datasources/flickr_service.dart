import 'package:dio/dio.dart';
import '../models/flickr_photo_model.dart';

class FlickrService {
  final Dio _dio = Dio();
  final String _apiKey = '997270535fe82de9b8d3f18201921055';

  Future<FlickrResponseModel> searchPhotos(String query, int page) async {
    final response = await _dio.get(
      'https://api.flickr.com/services/rest/',
      queryParameters: {
        'method': 'flickr.photos.search',
        'api_key': _apiKey,
        'text': query,
        'format': 'json',
        'nojsoncallback': 1,
        'page': page,
      },
    );

    return FlickrResponseModel.fromJson(response.data['photos']);
  }

  String getPhotoUrl(FlickrPhotoModel photo) {
    return 'https://farm${photo.farm}.staticflickr.com/${photo.server}/${photo.id}_${photo.secret}.jpg';
  }
}
