import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo_model.dart';
import '../screens/detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class PhotoGridItem extends StatelessWidget {
  final Photo photo;

  PhotoGridItem({required this.photo});

  void _processImageInBackground(String imageUrl) async {
    final receivePort = ReceivePort();
    try {
      await Isolate.spawn(_imageProcessor, [imageUrl, receivePort.sendPort]);
      final result = await receivePort.first;
      if (result is bool && result) {
        print('Image processed successfully: $imageUrl');
      } else {
        throw 'Image processing failed for $imageUrl';
      }
    } catch (error) {
      print('Error processing image: $error');
    }
  }

  static void _imageProcessor(List<dynamic> args) {
    final String imageUrl = args[0];
    final SendPort sendPort = args[1];

    try {
      print('Processing image: $imageUrl');
      final isSuccessful = true;
      Future.delayed(Duration(seconds: 1), () {
        sendPort.send(isSuccessful);
      });
    } catch (error) {
      sendPort.send(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (MediaQuery.of(context).size.width / 2) - 12;

    _processImageInBackground(photo.thumbnail);

    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(photo: photo)),
            ),
        child: CachedNetworkImage(
          imageUrl: photo.thumbnail,
          placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                  width: itemHeight,
                  height: itemHeight,
                  margin: EdgeInsets.all(4.0),
                  color: Colors.grey[300])),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ));
  }
}
