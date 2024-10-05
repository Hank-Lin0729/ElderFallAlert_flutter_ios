// photo_gallery_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({Key? key}) : super(key: key);

  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  List<String> photoUrls = [];
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }


  Future<void> fetchPhotos({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse(
        '$baseUrl/API_get_latest_photos?page=$page&per_page=5');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token ?? ''
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        photoUrls = List<String>.from(data['photo_urls']);
        currentPage = data['current_page'];
        totalPages = data['total_pages'];
      });
    } else {
      // Handle error
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(data['error'] ?? '無法取得照片'),
          );
        },
      );
    }
  }

  void loadNextPage() {
    if (currentPage < totalPages) {
      fetchPhotos(page: currentPage + 1);
    }
  }

  void loadPrevPage() {
    if (currentPage > 1) {
      fetchPhotos(page: currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('照片展示'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: photoUrls
                  .map((url) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes != 0
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              currentPage > 1
                  ? ElevatedButton(
                      onPressed: loadPrevPage, child: const Text('上一頁'))
                  : const SizedBox.shrink(),
              currentPage < totalPages
                  ? ElevatedButton(
                      onPressed: loadNextPage, child: const Text('下一頁'))
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}