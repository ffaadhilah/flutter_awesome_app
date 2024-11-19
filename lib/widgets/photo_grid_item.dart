import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo_model.dart';
import '../screens/detail_screen.dart';

class PhotoGridItem extends StatelessWidget {
  final Photo photo;

  PhotoGridItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(photo: photo)),
      ),
      child: CachedNetworkImage(
        imageUrl: photo.thumbnail,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
