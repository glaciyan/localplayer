import 'package:localplayer/spotify/domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel.fromJson(final Map<String, dynamic> json)
      : super(
          id: json['id'],
          name: json['name'],
          artist: json['artists'][0]['name'],
          imageUrl: json['album']['images'][0]['url'],
          previewUrl: json['preview_url'],
        );
}