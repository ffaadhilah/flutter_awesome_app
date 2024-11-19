import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../screens/detail_screen.dart';

class PhotoListItem extends StatelessWidget {
  final Photo photo;

  PhotoListItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(photo.thumbnail, fit: BoxFit.cover),
      title: Text(photo.photographer),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(photo: photo)),
      ),
    );
  }
}
