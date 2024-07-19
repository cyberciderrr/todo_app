import 'package:ToDoApp/domain/repositories/flickr_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/service_locator.dart';
import '../cubits/photo_search_cubit.dart';


class PhotoSearchScreen extends StatefulWidget {
  final Function(String) onPhotoSelected;

  const PhotoSearchScreen({required this.onPhotoSelected});

  @override
  _PhotoSearchScreenState createState() => _PhotoSearchScreenState();
}

class _PhotoSearchScreenState extends State<PhotoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMorePhotos();
      }
    });
  }

  void _loadMorePhotos() {
    final state = context.read<PhotoSearchCubit>().state;
    if (state is PhotoSearchLoaded && state.hasMore) {
      context.read<PhotoSearchCubit>().searchPhotos(_searchController.text, _page + 1);
      setState(() {
        _page++;
      });
    }
  }

  void _searchPhotos() {
    context.read<PhotoSearchCubit>().searchPhotos(_searchController.text, 1);
    setState(() {
      _page = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoSearchCubit(flickrRepository: sl<FlickrRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Photos'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _searchPhotos,
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PhotoSearchCubit, PhotoSearchState>(
                builder: (context, state) {
                  if (state is PhotoSearchLoading && _page == 1) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PhotoSearchLoaded) {
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: state.photos.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.photos.length) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final photo = state.photos[index];
                        final url = context.read<PhotoSearchCubit>().flickrRepository.getPhotoUrl(photo);

                        return GestureDetector(
                          onTap: () {
                            widget.onPhotoSelected(url);
                            Navigator.of(context).pop();
                          },
                          child: Image.network(url, fit: BoxFit.cover),
                        );
                      },
                    );
                  } else if (state is PhotoSearchError) {
                    return Center(child: Text(state.message));
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
