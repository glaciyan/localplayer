import 'package:localplayer/core/domain/models/profile.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<FeedPost> posts;
  final bool hasMore;
  
  FeedLoaded({
    required this.posts,
    this.hasMore = true,
  });
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}

class FeedPost {
  final String id;
  final Profile author;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;
  final String? spotifyTrackId;

  FeedPost({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.isLiked,
    this.spotifyTrackId,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) => FeedPost(
    id: json['id'] as String,
    author: Profile.fromJson(json['author'] as Map<String, dynamic>),
    content: json['content'] as String,
    imageUrl: json['imageUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    likeCount: json['likeCount'] as int,
    isLiked: json['isLiked'] as bool,
    spotifyTrackId: json['spotifyTrackId'] as String?,
  );
}
