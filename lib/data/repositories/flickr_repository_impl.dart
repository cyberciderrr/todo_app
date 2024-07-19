import '../../domain/entities/flickr_photo.dart';
import '../../domain/repositories/flickr_repository.dart';
import '../datasources/flickr_service.dart';
import '../models/flickr_photo_model.dart';

class FlickrRepositoryImpl implements FlickrRepository {
  final FlickrService flickrService;

  FlickrRepositoryImpl(this.flickrService);

  @override
  Future<List<FlickrPhoto>> searchPhotos(String query, int page) async {
    final response = await flickrService.searchPhotos(query, page);
    return response.photo.map((photoModel) => FlickrPhoto(
      id: photoModel.id,
      owner: photoModel.owner,
      secret: photoModel.secret,
      server: photoModel.server,
      farm: photoModel.farm,
      title: photoModel.title,
    )).toList();
  }

  @override
  String getPhotoUrl(FlickrPhoto photo) {
    final photoModel = FlickrPhotoModel(
      id: photo.id,
      owner: photo.owner,
      secret: photo.secret,
      server: photo.server,
      farm: photo.farm,
      title: photo.title,
    );
    return flickrService.getPhotoUrl(photoModel);
  }
}
