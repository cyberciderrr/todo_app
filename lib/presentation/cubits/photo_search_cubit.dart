import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/flickr_photo.dart';
import '../../domain/repositories/flickr_repository.dart';

part 'photo_search_state.dart';

class PhotoSearchCubit extends Cubit<PhotoSearchState> {
  final FlickrRepository flickrRepository;

  PhotoSearchCubit({required this.flickrRepository}) : super(PhotoSearchInitial());

  void searchPhotos(String query, int page) async {
    if (state is PhotoSearchLoading) return;

    emit(PhotoSearchLoading());

    try {
      final photos = await flickrRepository.searchPhotos(query, page);
      final hasMore = photos.length >= 100;
      emit(PhotoSearchLoaded(photos, hasMore));
    } catch (e) {
      emit(PhotoSearchError('Failed to load photos'));
    }
  }
}
