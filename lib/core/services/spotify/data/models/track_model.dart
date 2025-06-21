import '../../domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel({
    required super.id,
    required super.name,
    required super.artist,
    required super.imageUrl,
    required super.previewUrl,
  });

  factory TrackModel.fromJson(final Map<String, dynamic> json) => TrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      artist: ((json['artists'] as List<dynamic>)[0] as Map<String, dynamic>)['name'] as String,
      imageUrl: (((json['album'] as Map<String, dynamic>)['images'] as List<dynamic>)[0] as Map<String, dynamic>)['url'] as String,
      previewUrl: json['preview_url'] as String?,
    );
}