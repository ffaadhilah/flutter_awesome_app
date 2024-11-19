import 'package:flutter/material.dart';
import '../models/photo_model.dart';

class DetailScreen extends StatelessWidget {
  final Photo photo;

  DetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.photographer)),
      body: Column(
        children: [
          Expanded(
            child: Image.network(photo.url, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Photographer: ${photo.photographer}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text('URL: ${photo.url}', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
