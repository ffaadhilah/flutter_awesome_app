import 'package:flutter/material.dart';
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
      child: Image.network(photo.thumbnail, fit: BoxFit.cover),
    );
  }
}
