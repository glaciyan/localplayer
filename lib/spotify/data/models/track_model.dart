import 'package:localplayer/spotify/domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel.fromJson(final Map<String, dynamic> json)
      : super(
          id: json['id']?.toString() ?? '',
          name: json['name']?.toString() ?? '',
          artist: ((json['artists'] as List<dynamic>?)?[0] as Map<String, dynamic>?)?['name']?.toString() ?? '',
          imageUrl: (((json['album'] as Map<String, dynamic>?)?['images'] as List<dynamic>?)?[0] as Map<String, dynamic>?)?['url']?.toString() ?? '',
          previewUrl: json['preview_url']?.toString() ?? '',
        );
}