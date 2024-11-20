import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../screens/detail_screen.dart';

class PhotoListItem extends StatelessWidget {
  final Photo photo;

  PhotoListItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ]),
      child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(
                photo.thumbnail,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              )),
          title: Text(photo.photographer),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(photo: photo)),
              )),
    );
  }
}
