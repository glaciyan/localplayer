import '../../domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel({
    required String id,
    required String name,
    required String artist,
    required String imageUrl,
    required String? previewUrl,
  }) : super(
          id: id,
          name: name,
          artist: artist,
          imageUrl: imageUrl,
          previewUrl: previewUrl,
        );

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'],
      name: json['name'],
      artist: json['artists'][0]['name'],
      imageUrl: json['album']['images'][0]['url'],
      previewUrl: json['preview_url'],
    );
  }
}