import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/flickr_service.dart';
import '../../core/service_locator.dart';

class PhotoSearchScreen extends StatefulWidget {
  final Function(String) onPhotoSelected;

  const PhotoSearchScreen({required this.onPhotoSelected});

  @override
  _PhotoSearchScreenState createState() => _PhotoSearchScreenState();
}

class _PhotoSearchScreenState extends State<PhotoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<FlickrPhoto> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore) {
        _searchPhotos();
      }
    });
  }

  void _searchPhotos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final flickrService = sl<FlickrService>();
      final response = await flickrService.searchPhotos(_searchController.text, _page);

      setState(() {
        _photos.addAll(response.photo);
        _hasMore = _page < response.pages;
        _page++;
      });
    } catch (e) {
      print('Failed to load photos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () {
                    setState(() {
                      _photos.clear();
                      _page = 1;
                      _hasMore = true;
                    });
                    _searchPhotos();
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _photos.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _photos.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final photo = _photos[index];
                final url = sl<FlickrService>().getPhotoUrl(photo);

                return GestureDetector(
                  onTap: () {
                    widget.onPhotoSelected(url);
                    Navigator.of(context).pop();
                  },
                  child: Image.network(url, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
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
