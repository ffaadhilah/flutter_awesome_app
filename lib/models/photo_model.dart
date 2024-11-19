class Photo {
  final String id;
  final String photographer;
  final String url;
  final String thumbnail;

  Photo({
    required this.id,
    required this.photographer,
    required this.url,
    required this.thumbnail,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'].toString(),
      photographer: json['photographer'],
      url: json['src']['large'],
      thumbnail: json['src']['medium'],
    );
  }
}
