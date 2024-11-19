import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_model.dart';

class PexelsService {
  static const _baseUrl = 'https://api.pexels.com/v1/';
  static const _apiKey =
      '563492ad6f917000010000011bab5181d8e7469d874a626a549d0a38';
  Future<List<Photo>> fetchPhotos(int page, int perPage) async {
    final url = Uri.parse('${_baseUrl}curated?page=$page&per_page=$perPage');
    final response = await http.get(url, headers: {'Authorization': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['photos'] as List;
      return data.map((photo) => Photo.fromJson(photo)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
