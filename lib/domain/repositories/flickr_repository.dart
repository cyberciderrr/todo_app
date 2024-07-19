import '../entities/flickr_photo.dart';

abstract class FlickrRepository {
  Future<List<FlickrPhoto>> searchPhotos(String query, int page);
  String getPhotoUrl(FlickrPhoto photo);
}
