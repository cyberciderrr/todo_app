part of 'photo_search_cubit.dart';

@immutable
abstract class PhotoSearchState {}

class PhotoSearchInitial extends PhotoSearchState {}

class PhotoSearchLoading extends PhotoSearchState {}

class PhotoSearchLoaded extends PhotoSearchState {
  final List<FlickrPhoto> photos;
  final bool hasMore;

  PhotoSearchLoaded(this.photos, this.hasMore);
}

class PhotoSearchError extends PhotoSearchState {
  final String message;

  PhotoSearchError(this.message);
}
